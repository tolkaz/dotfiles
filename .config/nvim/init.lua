local lazy_path = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazy_path) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazy_path,
    })
end
vim.opt.rtp:prepend(lazy_path)

local lazy_opts = {
    change_detection = {
        enabled = true,
        notify = false,
    },
}

require("lazy").setup(
    { { import = "plugins" } },
    lazy_opts
)
