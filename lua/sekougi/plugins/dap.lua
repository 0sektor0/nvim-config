local is_windows = vim.fn.has("win32") == 1

local platform = {
    console = "integratedTerminal",
    dap_detached = not is_windows,
    exe_suffix = is_windows and ".exe" or "",
    mason_bin = vim.fn.stdpath("data") .. "/mason/bin",
    mason_packages = vim.fn.stdpath("data") .. "/mason/packages",
}

local function mason_executable(name)
    if is_windows then
        return platform.mason_bin .. "/" .. name .. ".cmd"
    end

    return platform.mason_bin .. "/" .. name
end

local function netcoredbg_executable()
    if is_windows then
        return vim.fs.joinpath(platform.mason_packages, "netcoredbg", "netcoredbg", "netcoredbg.exe")
    end

    return mason_executable("netcoredbg")
end

local function rust_env()
    local env_vars = {}
    for k, v in pairs(vim.fn.environ()) do
        env_vars[k] = v
    end
    env_vars.RUST_BACKTRACE = "1"
    return env_vars
end

local function rust_binary_path()
    local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":t")
    return vim.fs.joinpath(vim.fn.getcwd(), "target", "debug", project_name .. platform.exe_suffix)
end

local function build_rust_sync()
    vim.notify("[dap] Running cargo build...", vim.log.levels.INFO)
    local output = vim.fn.system("cargo build 2>&1")
    if vim.v.shell_error ~= 0 then
        vim.notify("cargo build failed:\n" .. output, vim.log.levels.ERROR)
        return false
    end
    return true
end

local function get_rust_binary_built()
    if build_rust_sync() then
        return rust_binary_path()
    end
    return nil
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
            program = get_rust_binary_built,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
            args = {},
            env = rust_env,
            terminal = "integrated",
            console = platform.console,
            sourceLanguages = { "rust" },
        },
        {
            name = "Debug with args",
            type = "codelldb",
            request = "launch",
            program = get_rust_binary_built,
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
                local test_name = vim.fn.input('Test name (optional): ')
                if not build_rust_sync() then
                    return nil
                end
                if test_name ~= "" then
                    return vim.fs.joinpath(vim.fn.getcwd(), "target", "debug", "deps", test_name .. platform.exe_suffix)
                else
                    return rust_binary_path()
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
        command = netcoredbg_executable(),
        args = { "--interpreter=vscode" },
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "Launch .NET app",
            request = "launch",
            program = function()
                return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
            end,
            cwd = "${workspaceFolder}",
            stopAtEntry = false,
            console = platform.console,
        },
        {
            type = "coreclr",
            name = "Attach to .NET process",
            request = "attach",
            processId = require("dap.utils").pick_process,
        },
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

 local function config_go()
    local dap = require("dap")

    dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
            command = mason_executable("dlv"),
            args = { "dap", "-l", "127.0.0.1:${port}" },
            detached = platform.dap_detached
        }
    }

    dap.configurations.go = {
        {
            type = "delve",
            name = "Debug",
            request = "launch",
            program = "${fileDirname}",
            console = platform.console,
        },
        {
            type = "delve",
            name = "Debug test",
            request = "launch",
            program = "${fileDirname}",
            args = function()
                local test_name = vim.fn.input("Test name (optional): ")
                if test_name ~= "" then
                    return { "-test.run", test_name }
                end
                return {}
            end,
            console = platform.console,
        },
        {
            type = "delve",
            name = "Debug attach",
            request = "attach",
            mode = "local",
            program = "${fileDirname}",
            console = platform.console,
        },
        {
            type = "delve",
            name = "Debug with args",
            request = "launch",
            program = "${fileDirname}",
            args = function()
                local args_string = vim.fn.input("Arguments: ")
                return vim.split(args_string, " ")
            end,
            console = platform.console,
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
        config_go()
        config_keymap()
    end,
}
