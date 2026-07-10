local is_windows = vim.fn.has("win32") == 1

local platform = {
    console = is_windows and "integratedTerminal" or "integratedConsole",
    dap_detached = not is_windows,
    exe_suffix = is_windows and ".exe" or "",
    mason_bin = vim.fn.stdpath("data") .. "/mason/bin",
}

local function mason_executable(name)
    if is_windows then
        return platform.mason_bin .. "/" .. name .. ".cmd"
    end

    return platform.mason_bin .. "/" .. name
end

local function get_rust_binary()
    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
end

local function config_rust()
    local dap = require("dap")

    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = mason_executable("codelldb"),
            args = { "--port", "${port}" },
            detached = platform.dap_detached
        }
    }

    dap.configurations.rust = {
        {
            name = "Debug Rust",
            type = "codelldb",
            request = "launch",
            program = get_rust_binary,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            env = function()
                local env_vars = {}
                -- Copy environment variables from the current session
                for k, v in pairs(vim.fn.environ()) do
                    env_vars[k] = v
                end
                env_vars.RUST_BACKTRACE = "1"
                return env_vars
            end,
            terminal = "integrated",
            console = platform.console,
            sourceLanguages = { "rust" },
        },
        {
            name = "Debug with args",
            type = "codelldb",
            request = "launch",
            program = get_rust_binary,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = function()
                local args_string = vim.fn.input('Arguments: ')
                return vim.split(args_string, " ")
            end,
            console = platform.console,
        },
        {
            name = "Debug test",
            type = "codelldb",
            request = "launch",
            program = function()
                -- For tests, use cargo test to determine the binary
                local test_name = vim.fn.input('Test name (optional): ')
                if test_name ~= "" then
                    return vim.fs.joinpath(vim.fn.getcwd(), "target", "debug", "deps", test_name .. platform.exe_suffix)
                else
                    return get_rust_binary()
                end
            end,
            cwd = '${workspaceFolder}',
            args = {},
            console = platform.console,
        }
    }
end

local function config_cs()
    local dap = require("dap")

    dap.adapters.coreclr = {
        type = "executable",
        command = mason_executable("netcoredbg"),
        args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "Attach to Unity",
            request = "attach",
            processId = function()
                return require("dap.utils").pick_process({
                    prompt = "Select Unity process: ",
                    filter = function(proc)
                        local name = vim.fs.basename(proc.name)

                        return name == "Unity" or name == "Unity.exe"
                    end,
                })
            end,
        },
    }
end

local function config_keymap()
    local dap = require("dap")

    vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
    vim.keymap.set("n", "<F6>", dap.step_over, { desc = "Debug: Step Over" })
    vim.keymap.set("n", "<F7>", dap.step_into, { desc = "Debug: Step Into" })
    vim.keymap.set("n", "<F8>", dap.step_out, { desc = "Debug: Step Out" })
    vim.keymap.set("n", "<F4>", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
    vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })

    vim.keymap.set("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
    end, { desc = "Debug: Conditional Breakpoint" })
end

return {
    "mfussenegger/nvim-dap",
    config = function()
        config_rust()
        config_cs()
        config_keymap()
    end,
}
