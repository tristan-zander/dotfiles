return {
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.8',
        dependencies = {'nvim-lua/plenary.nvim'},
        config = function()
            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files,
                           {desc = '[F]ind [F]iles'})
            vim.keymap.set('n', '<leader>fg', builtin.live_grep,
                           {desc = '[F]ind [G]rep'})
            vim.keymap.set('n', '<leader>fb', builtin.buffers,
                           {desc = '[F]ind [B]uffer'})
            vim.keymap.set('n', '<leader>fh', builtin.help_tags,
                           {desc = '[F]ind [H]elp'})

            vim.api.nvim_create_autocmd('LspAttach', {
                group = vim.api
                    .nvim_create_augroup('lsp-attach', {clear = true}),
                callback = function(event)
                    local map = function(keys, func, desc)
                        vim.keymap.set('n', keys, func, {
                            buffer = event.buf,
                            desc = 'LSP: ' .. desc
                        })
                    end

                    map('gd', builtin.lsp_definitions, '[G]oto [D]efinition')

                    map('gr', builtin.lsp_references, '[G]oto [R]eferences')
                    map('gI', builtin.lsp_implementations,
                        '[G]oto [I]mplementation')

                    -- Jump to the type of the word under your cursor.
                    --  Useful when you're not sure what type a variable is and you want to see
                    --  the definition of its *type*, not where it was *defined*.
                    map('<leader>D', builtin.lsp_type_definitions,
                        'Type [D]efinition')

                    -- Fuzzy find all the symbols in your current document.
                    --  Symbols are things like variables, functions, types, etc.
                    map('<leader>ds', builtin.lsp_document_symbols,
                        '[D]ocument [S]ymbols')

                    -- Fuzzy find all the symbols in your current workspace.
                    --  Similar to document symbols, except searches over your entire project.
                    map('<leader>ws', builtin.lsp_dynamic_workspace_symbols,
                        '[W]orkspace [S]ymbols')

                    -- Rename the variable under your cursor.
                    --  Most Language Servers support renaming across files, etc.
                    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

                    -- Execute a code action, usually your cursor needs to be on top of an error
                    -- or a suggestion from your LSP for this to activate.
                    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

                    -- Opens a popup that displays documentation about the word under your cursor
                    --  See `:help K` for why this keymap.
                    map('K', vim.lsp.buf.hover, 'Hover Documentation')

                    -- WARN: This is not Goto Definition, this is Goto Declaration.
                    --  For example, in C this would take you to the header.
                    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

                end
            })

        end
    }

}

