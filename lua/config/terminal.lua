local state = {
    terminal = {
        buf = -1,
        win = -1,
    },
}
local function createTerminal(opts)
    opts = opts or {}
    if opts.buf == nil then
        opts.buf = -1
    end
    if opts.win == nil then
        opts.win = -1
    end
    local height = math.floor(vim.o.lines * 0.4)

    local buf = nil
    local win = nil
    if vim.api.nvim_buf_is_valid(opts.buf) and vim.api.nvim_win_is_valid(opts.win) then
        buf = opts.buf
        win = opts.win
    else
        if not vim.api.nvim_buf_is_valid(opts.buf) then
            buf = vim.api.nvim_create_buf(false, true)
        else
            buf = opts.buf
        end
        vim.cmd("botright split")
        win = vim.api.nvim_get_current_win()
    end

    vim.api.nvim_win_set_buf(win, buf)
    vim.api.nvim_win_set_height(win, height)
    if vim.bo.buftype ~= "terminal" then
        vim.cmd.term()
    end

    return { buf = buf, win = win }
end

vim.api.nvim_create_user_command("CustTerminal", function()
    if not vim.api.nvim_buf_is_valid(state.terminal.buf) then
        state.terminal = createTerminal()
    elseif not vim.api.nvim_win_is_valid(state.terminal.win) then
        state.terminal = createTerminal({ buf = state.terminal.buf })
    else
        vim.api.nvim_win_close(state.terminal.win, true)
    end
end, {})

vim.keymap.set({ "n", "t" }, "<leader>t", "<cmd>CustTerminal<CR>", { desc = "Toggle Terminal" })
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>", { desc = "Terminal go to normal mode" })
