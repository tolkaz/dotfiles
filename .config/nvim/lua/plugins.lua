return {
    { "tpope/vim-fugitive" },
    { "neovim/nvim-lspconfig" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp" },
    {
        "hrsh7th/nvim-cmp",
        config = function()
	    local cmp = require("cmp")
            local lspconfig = require("lspconfig")

            -- condition sets whether the server is setup for the local server
            local capabilities = require("cmp_nvim_lsp").default_capabilities(
                vim.lsp.protocol.make_client_capabilities()
            )
            
                        local cmdlineMapping = cmp.mapping.preset.cmdline({
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if vim.fn.pumvisible() == 1 then
                        local next_key = vim.api.nvim_replace_termcodes("<C-n>", true, false, true)
                        vim.api.nvim_feedkeys(next_key, "c", false)
                    elseif cmp.visible() then
                        cmp.select_next_item()
                    else
                        cmp.complete()
                        fallback()
                    end
                end, { "c" }),
                ["<C-y>"] = {
                    c = function(fallback)
                        if vim.fn.pumvisible() == 1 or not cmp.visible() then
                            fallback()
                        else
                            cmp.confirm({ select = true })
                        end
                    end,
                },
            })
            


            -- Use buffer source for `/` and `?`
            cmp.setup.cmdline({ "/", "?" }, {
                mapping = cmdlineMapping,
                sources = {
                    { name = "buffer" }
                }
            })

            -- Use cmdline & path source for ":"
            cmp.setup.cmdline(":", {
                mapping = cmdlineMapping,
                sources = cmp.config.sources({
                    { name = "path" }
                }, {
                    { name = "cmdline", option = { ignore_cmds = { "Man", "!", "edit", "write", } } }
                })
            })
            
                        cmp.setup({
                formatting = {
                    expandable_indicator = true,
                    fields = { 'abbr', 'kind', 'menu' },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.confirm({ select = true })
                        else
                            fallback() -- fallback sends existing mapping
                        end
                    end, { "i", "s" }),
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                }, {
                    { name = "path" },
                    { name = "buffer" },
                })
            })
         
            local languageServers = {
                bashls = {},
                jsonls = {
                    filetypes = { "json", "jsonc" },
                },
                marksman = {},
                pyright = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            },
                            workspace = {
                                checkThirdParty = false,
                                library = {
                                    [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                                    [vim.fn.expand("$VIMRUNTIME/lua/vim/lsp")] = true
                                }
                            },
                        },
                    },
                },
                vimls = {},
                yamlls = {}
            }

            for lsp, options in pairs(languageServers) do
                if options.condition == nil or options.condition then
                    options.capabilities = options.capabilities or capabilities
                    lspconfig[lsp].setup(options)
                end
            end
        end,
    },
}
