-- Git related plugins
return {
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "|" },
					change = { text = "|" },
					delete = { text = "|" },
					topdelete = { text = "|" },
					changedelete = { text = "|" },
					untracked = { text = "|" },
				},
			})
		end,
	},
    -- Lazygit is in toggleterm.lua
    {
        "ttbug/tig.nvim",
        config = function()
            require("tig").setup({
                window = {
                    options = {
                        -- Width, height window in %
                        width = 70,
                        height = 70,
                        border = "single",
                    },
                },
            })
        end
    }
}
