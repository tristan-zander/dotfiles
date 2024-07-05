return {
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {"williamboman/mason.nvim", "neovim/nvim-lspconfig"},
        config = function()
            local mason_lspconfig = require("mason-lspconfig")
            local lspconfig = require("lspconfig")
            mason_lspconfig.setup()

            mason_lspconfig.setup_handlers {
                -- The first entry (without a key) will be the default handler
                -- and will be called for each installed server that doesn't have
                -- a dedicated handler.
                function(server_name) -- default handler (optional)
                    lspconfig[server_name].setup {}
                end
                -- Next, you can provide a dedicated handler for specific servers.
                -- For example, a handler override for the `rust_analyzer`:
                -- ["rust_analyzer"] = function ()
                -- require("rust-tools").setup {}
                -- end
            }
        end
    }, {
        "williamboman/mason.nvim",
        config = function()
            local mason = require("mason")
            mason.setup()
        end
    }, {
        "neovim/nvim-lspconfig",
        dependencies = {
            -- `neodev` configures Lua LSP for your Neovim config, runtime and plugins
            -- used for completion, annotations and signatures of Neovim apis
            {'folke/neodev.nvim', opts = {}}
        }

    }, {
        "stevearc/conform.nvim",
        config = function()
            local conform = require("conform")

            conform.setup({
                formatters_by_ft = {lua = {"lua-format"}},
                format_on_save = function(bufnr)
                    -- Disable with a global or buffer-local variable
                    if vim.g.disable_autoformat or
                        vim.b[bufnr].disable_autoformat then
                        return
                    end
                    return {timeout_ms = 500, lsp_format = "fallback"}

                end
            })

            -- Create user commands to toggle auto formatting
            vim.api.nvim_create_user_command("FormatDisable", function(args)
                if args.bang then
                    -- FormatDisable! will disable formatting just for this buffer
                    vim.b.disable_autoformat = true
                else
                    vim.g.disable_autoformat = true
                end
            end, {desc = "Disable autoformat-on-save", bang = true})
            vim.api.nvim_create_user_command("FormatEnable", function(args)
                if args.bang then
                    -- FormatEnable! will enable formatting just for this buffer
                    vim.b.disable_autoformat = false
                else
                    vim.g.disable_autoformat = false
                end
            end, {desc = "Re-enable autoformat-on-save", bang = true})

            -- toggle buffer formatting
            vim.keymap.set('n', '<leader>tfb', function()
                if vim.b == nil then return end

                if vim.b.disable_autoformat == false then
                    vim.api.nvim_command("FormatDisable!")
                    vim.print("disabled buffer autoformat")
                else
                    vim.api.nvim_command("FormatEnable!")
                    vim.print("enabled buffer autoformat")
                end
            end, {desc = '[T]oggle [F]ormatter ([B]uffer)'})

            -- toggle global formatting
            vim.keymap.set('n', '<leader>tfg', function()
                if vim.g.disable_autoformat == false then
                    vim.api.nvim_command("FormatDisable")
                    vim.print("disabled global autoformat")
                else
                    vim.api.nvim_command("FormatEnable")
                    vim.print("enabled global autoformat")
                end
            end, {desc = '[T]oggle [F]ormatter ([B]uffer)'})

        end

    }
}
