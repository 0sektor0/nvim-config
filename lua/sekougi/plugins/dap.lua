local function get_os()
    if package.config:sub(1, 1) == '\\' then
        return "windows"
    else
        local homedir = os.getenv("HOME")
        if homedir then
            return "unix"
        else
            return "unknown"
        end
    end
end

local function get_codelldb_path()
    local os_type = get_os()
    local mason_bin = vim.fn.stdpath("data") .. "/mason/bin"

    if os_type == "windows" then
        return mason_bin .. "/codelldb.cmd"
    else
        return mason_bin .. "/codelldb"
    end
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
            command = get_codelldb_path(),
            args = { "--port", "${port}" },
            detached = get_os() == "windows" and false or true
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
                -- Копируем переменные окружения текущей сессии
                for k, v in pairs(vim.fn.environ()) do
                    env_vars[k] = v
                end
                env_vars.RUST_BACKTRACE = "1"
                return env_vars
            end,
            terminal = "integrated",
            console = get_os() == "windows" and "integratedTerminal" or "integratedConsole",
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
            console = get_os() == "windows" and "integratedTerminal" or "integratedConsole",
        },
        {
            name = "Debug test",
            type = "codelldb",
            request = "launch",
            program = function()
                local os_type = get_os()
                local path_separator = os_type == "windows" and "\\" or "/"
                local binary_extension = os_type == "windows" and ".exe" or ""

                -- Для тестов используем cargo test для определения бинарника
                local test_name = vim.fn.input('Test name (optional): ')
                if test_name ~= "" then
                    return vim.fn.getcwd() ..
                        path_separator ..
                        "target" ..
                        path_separator ..
                        "debug" .. path_separator .. "deps" .. path_separator .. test_name .. binary_extension
                else
                    return get_rust_binary()
                end
            end,
            cwd = '${workspaceFolder}',
            args = {},
            console = get_os() == "windows" and "integratedTerminal" or "integratedConsole",
        }
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
        config_keymap()
    end,
}
