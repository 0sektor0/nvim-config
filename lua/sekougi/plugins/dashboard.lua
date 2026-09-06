return {
    'nvimdev/dashboard-nvim',
    event = 'VimEnter',
    config = function()
        require('dashboard').setup {

        }
    end,
    dependencies = { 'nivm-tree/nvim-web-devicons' }
}
