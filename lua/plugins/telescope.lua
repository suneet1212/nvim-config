return {
    "nvim-telescope/telescope.nvim",
    version = "*",
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- optional but recommended
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
        require("telescope").setup({
            pickers = {
                find_files = {
                    file_ignore_patterns = {
                        "target/",
                        ".venv/",
                        ".git/",
                    },
                    hidden = true,
                },
                diagnostics = {
                    theme = "ivy",
                },
            },
            extensions = {
                fzf = {},
            },
        })
        require("telescope").load_extension("fzf")

        vim.keymap.set("n", "<leader>fh", require("telescope.builtin").help_tags, { desc = "Telescope help tags" })
        vim.keymap.set("n", "<leader>fd", require("telescope.builtin").find_files, { desc = "Telescope find files" })
        vim.keymap.set("n", "<leader>fb", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
        vim.keymap.set("n", "<leader>fk", require("telescope.builtin").keymaps, { desc = "Telescope keymaps" })
        vim.keymap.set(
            "n",
            "<leader>fc",
            require("telescope.builtin").command_history,
            { desc = "Telescope command history" }
        )
        vim.keymap.set("n", "<leader>en", function()
            require("telescope.builtin").find_files({
                cwd = vim.fn.stdpath("config"),
            })
        end)
        vim.keymap.set("n", "<leader>ep", function()
            require("telescope.builtin").find_files({
                cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy"),
            })
        end)
        vim.keymap.set("n", "<leader>fe", require("telescope.builtin").diagnostics, { desc = "Telescope diagnostics" })

        require("plugins.telescope.multigrep").setup()
    end,
}
