-- Autocompletion
return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-nvim-lua",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			{
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
            },
			"saadparwaiz1/cmp_luasnip",
			"rafamadriz/friendly-snippets",
		},
		config = function()
			-- for autopairs
			local cmp_autopairs = require('nvim-autopairs.completion.cmp')
			local cmp = require('cmp')
			cmp.event:on(
				'confirm_done',
				cmp_autopairs.on_confirm_done()
			)
            local luasnip = require("luasnip")

            -- make html and javascript snippets in php
            luasnip.filetype_extend("php", {"html", "javascript"})

            require("luasnip/loaders/from_vscode").lazy_load()

			local kind_icons = {
				Text = "󰊄",
				Method = "󰡱",
				Function = "󰡱",
				Constructor = "",
				Field = "",
				Variable = "󰫧",
				Class = "󱃢",
				Interface = "",
				Module = "",
				Property = "",
				Unit = "",
				Value = "x",
				Enum = "",
				Keyword = "",
				Snippet = "",
				Color = "󰌁",
				File = "󰈔",
				Reference = "",
				Folder = "󰉋",
				EnumMember = "",
				Constant = "c",
				Struct = "",
				Event = "",
				Operator = "",
				TypeParameter = "",
                Codeium = "",
			}

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(),
					["<C-j>"] = cmp.mapping.select_next_item(),
					["<C-d>"] = cmp.mapping.scroll_docs(-4),
					["<C-f>"] = cmp.mapping.scroll_docs(4),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = false,
					}),
					["<Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_next_item()
						elseif luasnip.expand_or_jumpable() then
							luasnip.expand_or_jump()
						else
							fallback()
						end
					end, { "i", "s" }),
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							cmp.select_prev_item()
						elseif luasnip.jumpable(-1) then
							luasnip.jump(-1)
						else
							fallback()
						end
					end, { "i", "s" }),
				}),
				formatting = {
                    -- disable names
					fields = { "kind", "abbr" --[[, "menu" ]] },
					format = function(entry, vim_item)
						-- Kind icons
						vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
						--[[ vim_item.menu = ({
							nvim_lsp = "[LSP]",
							luasnip = "[Snippet]",
							buffer = "[Buffer]",
							path = "[Path]",
                            codeium = "[AI]",
						})[entry.source.name] ]]
						return vim_item
					end,
				},
				sources = {
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
					{ name = "buffer" },
					{ name = "path" },
                    { name = "codeium" },
				},
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.clang_format,
				},
			})
		end,
	},
}
