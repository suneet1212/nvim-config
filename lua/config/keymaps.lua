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

vim.keymap.set("n", "<leader>q", function()
    -- ":bprevious | bdelete! #<CR>"
    if vim.bo.buftype == "terminal" then
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        vim.api.nvim_win_close(win, true)
        vim.api.nvim_buf_delete(buf, { force = true })
    elseif vim.bo.filetype == "oil" then
        local buf = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_delete(buf, { force = true })
    else
        local current = vim.api.nvim_get_current_buf()
        if vim.bo.modified then
            local choice =
                vim.fn.confirm("Save changes to " .. vim.api.nvim_buf_get_name(current) .. "?", "&Yes\n&No\n&Cancel", 3)
            if choice == 1 then           -- Yes
                vim.cmd("write")
            elseif choice == 3 or choice == 0 then -- Cancel (or dismissed)
                return
            end
            -- If No (choice == 2), it skips writing and proceeds to close/delete
        end
        local bufs = {}
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
            if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_is_loaded(buf) then
                if vim.api.nvim_buf_get_name(buf) == "" and vim.bo[buf].buftype == "" and not vim.bo[buf].modified then
                    -- do nothing
                elseif
                    vim.api.nvim_buf_get_name(buf) ~= ""
                    and vim.bo[buf].buftype == ""
                    and vim.api.nvim_get_current_buf() ~= buf
                then
                    table.insert(bufs, buf)
                end
            end
        end
        table.sort(bufs, function(a, b)
            return vim.fn.getbufinfo(a)[1].lastused > vim.fn.getbufinfo(b)[1].lastused
        end)
        if #bufs > 0 then
            vim.api.nvim_set_current_buf(bufs[1])
        else
            require("oil").open()
        end
        vim.api.nvim_buf_delete(current, { force = true })
    end
end, { silent = true })
