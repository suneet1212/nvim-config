vim.keymap.set("n", "<leader>pv", "<cmd>Oil<CR>")
vim.keymap.set("n", "<leader><leader>x", "<cmd>so<CR>")
vim.keymap.set("n", "<leader>x", ":.lua<CR>")
vim.keymap.set("v", "<leader>x", ":lua<CR>")

-- Lsp diagnostics
vim.keymap.set("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { desc = "diagnostics panel" }) -- diagnostic panel
vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1 })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = 1 })
end, { desc = "Next diagnostic" })

vim.keymap.set("n", "<C-d>", "<C-d>zz", { remap = false })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { remap = false })

vim.keymap.set("n", "<M-j>", "<cmd>cnext<CR>", { desc = "quickfix next" })
vim.keymap.set("n", "<M-k>", "<cmd>cprev<CR>", { desc = "quickfix prev" })

vim.keymap.set("n", "<C-/>", "gcc", { desc = "toggle comment", remap = true })
vim.keymap.set("v", "<C-/>", "gc", { desc = "toggle comment", remap = true })
