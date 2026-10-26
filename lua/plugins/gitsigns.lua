return { -- Adds git related signs to the gutter, as well as utilities for managing changes
    "lewis6991/gitsigns.nvim",
    ---@module 'gitsigns'
    ---@type Gitsigns.Config
    ---@diagnostic disable-next-line: missing-fields
    opts = {
        signs = {
            add = { text = "┃", show_count = true },
            change = { text = "┃", show_count = true },
            delete = { text = "_", show_count = true },
            topdelete = { text = "‾", show_count = true },
            changedelete = { text = "~", show_count = true },
            untracked = { text = "┆", show_count = true },
        },
        signs_staged = {
            add = { text = "┃" },
            change = { text = "┃" },
            delete = { text = "_" },
            topdelete = { text = "‾" },
            changedelete = { text = "~" },
            untracked = { text = "┆" },
        },
        show_count = nil,
        count_chars = {},
        numhl = false,
        linehl = false,
        current_line_blame = true,
    },
}
