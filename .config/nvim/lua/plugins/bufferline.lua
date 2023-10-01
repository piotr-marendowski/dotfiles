return {
	{
		"akinsho/bufferline.nvim",
		version = "v3.*",
		dependencies = "nvim-tree/nvim-web-devicons",
		config = function()
			local bufferline = require("bufferline")
			bufferline.setup({
				options = {
					indicator = {
						style = "none",
					},
					max_name_length = 25,
					max_prefix_length = 25, -- prefix used when a buffer is de-duplicated
					tab_size = 21,
					offsets = {
						{
							filetype = "Alpha",
							text = " ",
							text_align = "center",
							-- separator = true,
							padding = 1,
						},
					},
					show_buffer_close_icons = false,
					show_close_icon = false,
					show_tab_indicators = true,
					diagnostics = "nvim_lsp",
					diagnostics_indicator = function(count, level, diagnostics_dict, context)
						local s = ""
						for e, n in pairs(diagnostics_dict) do
							local sym = e == "error" and " " or (e == "warning" and " " or " ")
							s = s .. n .. sym
						end
						return s
					end,
				},
			})
			-- Navigate buffers
			local map = require("keys").map
			map("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>", "Next buffer")
			map("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>", "Previous buffer")
			map("n", "<A-l>", "<cmd>BufferLineMoveNext<CR>", "Move next buffer")
			map("n", "<A-h>", "<cmd>BufferLineMovePrev<CR>", "Move previous buffer")
            -- Fake ctrl + tab buffer switching ==> bind only tab
			map("n", "<Tab>", "<cmd>b#<CR>", "Alt tab")
		end,
	},
}
