return {
    "mfussenegger/nvim-dap",
    config = function()
        local dap = require("dap")

        -- Адаптер для Rust/C/C++ через LLDB
        dap.adapters.lldb = {
            type = "executable",
            command = "lldb-vscode", -- или путь к lldb-vscode
            name = "lldb"
        }

        -- Конфигурации для Rust
        dap.configurations.rust = {
            {
                name = "Rust Debug",
                type = "lldb",
                request = "launch",
                program = function()
                    -- Автоматически определяет путь к бинарнику
                    local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
                    if cargo_toml ~= "" then
                        local workspace = vim.fn.fnamemodify(cargo_toml, ":p:h")
                        local target_name = vim.fn.fnamemodify(workspace, ":t")
                        return "${workspaceFolder}/target/debug/" .. target_name
                    end
                    return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = {},
                env = {},
                terminal = "integrated",
            },
            {
                name = "Rust Debug (with args)",
                type = "lldb",
                request = "launch",
                program = function()
                    local cargo_toml = vim.fn.findfile("Cargo.toml", ".;")
                    if cargo_toml ~= "" then
                        local workspace = vim.fn.fnamemodify(cargo_toml, ":p:h")
                        local target_name = vim.fn.fnamemodify(workspace, ":t")
                        return "${workspaceFolder}/target/debug/" .. target_name
                    end
                    return "${workspaceFolder}/target/debug/${workspaceFolderBasename}"
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
                args = function()
                    local args = vim.fn.input("Program arguments: ")
                    return vim.split(args, " ")
                end,
            },
        }

        -- Клавиши для отладки
        vim.keymap.set("n", "<F5>", dap.continue, { desc = "Debug: Continue" })
        vim.keymap.set("n", "<F10>", dap.step_over, { desc = "Debug: Step Over" })
        vim.keymap.set("n", "<F11>", dap.step_into, { desc = "Debug: Step Into" })
        vim.keymap.set("n", "<F12>", dap.step_out, { desc = "Debug: Step Out" })
        vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
        vim.keymap.set("n", "<leader>dB", function()
            dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
        end, { desc = "Debug: Conditional Breakpoint" })
        vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: Open REPL" })
    end,
}
