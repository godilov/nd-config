vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.lsp.enable {
    'asm_lsp',
    'glsl_analyzer',
    'wgsl_analyzer',
    'rust_analyzer',
    'clangd',
    'solidity_ls_nomicfoundation',
    'postgres_lsp',

    'hls',
    'bashls',
    'lua_ls',
    'buf_ls',

    'denols',
    'biome',
    'docker_language_server',

    'taplo',
    'yamlls',
    'marksman',
    'tinymist',
    'hyprls',
}

vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            check = {
                command = 'clippy',
                extraEnv = {
                    ['RISC0_SKIP_BUILD'] = '1',
                    ['RISC0_SKIP_BUILD_KERNELS'] = '1',
                },
            },
            rustfmt = {
                overrideCommand = { 'rustfmt', '+nightly', '--edition', '2024' },
            },
            cargo = {
                features = 'all',
            },
        }
    }
})

vim.lsp.config('biome', {
    filetypes = { 'html', 'css', 'graphql', 'json', 'jsonc' }
})

vim.opt.mouse = 'a'
vim.opt.encoding = 'utf-8'
vim.opt.spelllang = { 'en' }
vim.opt.virtualedit = 'block'
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldlevel = 100

vim.opt.autowrite = true
vim.opt.autowriteall = true
vim.opt.autoindent = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.smartcase = true
vim.opt.smartindent = true
vim.opt.termguicolors = true
vim.opt.smoothscroll = true
vim.opt.confirm = true
vim.opt.list = true
vim.opt.undofile = true
vim.opt.undolevels = 10000

vim.opt.signcolumn = 'yes'
vim.opt.showmode = false
vim.opt.ruler = false

vim.opt.laststatus = 3
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.shiftround = true
vim.opt.scrolloff = 4
vim.opt.sidescrolloff = 4
vim.opt.pumheight = 16
vim.opt.timeout = true
vim.opt.timeoutlen = 200
vim.opt.updatetime = 500

vim.opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'

require('config.colors').set_editor_hls()
require('config.colors').set_syntax_hls()

vim.pack.add {
    { src = 'https://github.com/neovim/nvim-lspconfig.git' },
    { src = 'https://github.com/nvim-mini/mini.nvim.git', version = 'stable' },
}

local icons         = require('mini.icons')
local git           = require('mini.git')
local diff          = require('mini.diff')
local pick          = require('mini.pick')
local files         = require('mini.files')
local extra         = require('mini.extra')
local snippets      = require('mini.snippets')
local completion    = require('mini.completion')
local cmdline       = require('mini.cmdline')
local pairs         = require('mini.pairs')
local clue          = require('mini.clue')

local colors        = require('mini.colors')
local cursorword    = require('mini.cursorword')
local indentscope   = require('mini.indentscope')
local hipatterns    = require('mini.hipatterns')

local notify        = require('mini.notify')
local tabline       = require('mini.tabline')
local statusline    = require('mini.statusline')
local starter       = require('mini.starter')
local sessions      = require('mini.sessions')
local visits        = require('mini.visits')

icons.setup { style = 'ascii' }
git.setup()
diff.setup()
pick.setup()
files.setup()
extra.setup()
snippets.setup()
completion.setup()
cmdline.setup()
pairs.setup()
clue.setup {
    triggers = {
        { mode = { 'n', 'x' }, keys = '<Leader>' },

        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },
        { mode = 'n', keys = '<C-w>' },
        { mode = 'i', keys = '<C-x>' },

        { mode = { 'n', 'x' }, keys = 'g' },
        { mode = { 'n', 'x' }, keys = 'z' },
        { mode = { 'n', 'x' }, keys = '"' },
        { mode = { 'n', 'x' }, keys = "'" },
        { mode = { 'n', 'x' }, keys = "`" },
        { mode = { 'i', 'c' }, keys = '<C-r>' },
    },

    clues = {
        clue.gen_clues.g(),
        clue.gen_clues.z(),
        clue.gen_clues.marks(),
        clue.gen_clues.windows(),
        clue.gen_clues.registers(),
        clue.gen_clues.square_brackets(),
        clue.gen_clues.builtin_completion(),
    },

    window = {
        delay = 0,
    },
}

colors.setup()
cursorword.setup { delay = 0 }
indentscope.setup {
    draw = {
        delay = 0,
        animation = indentscope.gen_animation.linear({
            easing = 'in-out',
            duration = 200,
            unit = 'total',
        }),
    }
}

hipatterns.setup({
    highlighters = {
        hex = hipatterns.gen_highlighter.hex_color(),
    },
})

notify.setup()
tabline.setup()
statusline.setup()
starter.setup()
sessions.setup()
visits.setup()

require('mini.keymap').map_multistep('i', '<Tab>',   { 'pmenu_next' })
require('mini.keymap').map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
require('mini.keymap').map_multistep('i', '<CR>',    { 'pmenu_accept', 'minipairs_cr' })
require('mini.keymap').map_multistep('i', '<BS>',    { 'minipairs_bs' })

vim.keymap.set('v', '<', '<gv', { noremap = true })
vim.keymap.set('v', '>', '>gv', { noremap = true })

vim.keymap.set('n', '<A-h>', '<CMD>bprev<CR>',      { noremap = true, desc = 'Buffer Previous' })
vim.keymap.set('n', '<A-j>', '<CMD>bdelete<CR>',    { noremap = true, desc = 'Buffer Delete' })
vim.keymap.set('n', '<A-k>', '<CMD>enew<CR>',       { noremap = true, desc = 'Buffer Create' })
vim.keymap.set('n', '<A-l>', '<CMD>bnext<CR>',      { noremap = true, desc = 'Buffer Next' })

vim.keymap.set('n', '<C-A-H>', '<CMD>-tabmove<CR>', { noremap = true, desc = 'Tab Move Previous' })
vim.keymap.set('n', '<C-A-L>', '<CMD>+tabmove<CR>', { noremap = true, desc = 'Tab Move Next' })
vim.keymap.set('n', '<C-A-h>', '<CMD>tabprev<CR>',  { noremap = true, desc = 'Tab Previous' })
vim.keymap.set('n', '<C-A-j>', '<CMD>tabclose<CR>', { noremap = true, desc = 'Tab Delete' })
vim.keymap.set('n', '<C-A-k>', '<CMD>tabnew<CR>',   { noremap = true, desc = 'Tab Create' })
vim.keymap.set('n', '<C-A-l>', '<CMD>tabnext<CR>',  { noremap = true, desc = 'Tab Next' })

vim.keymap.set('n', '<Leader>sf', '<CMD>Pick files<CR>',                    { noremap = true, desc = 'Search Files' })
vim.keymap.set('n', '<Leader>se', '<CMD>Pick explorer<CR>',                 { noremap = true, desc = 'Search Explorer' })
vim.keymap.set('n', '<Leader>s/', '<CMD>Pick grep_live<CR>',                { noremap = true, desc = 'Search Grep (Live)' })
vim.keymap.set('n', '<Leader>sg', '<CMD>Pick grep<CR>',                     { noremap = true, desc = 'Search Grep' })
vim.keymap.set('n', '<Leader>sb', '<CMD>Pick buffers<CR>',                  { noremap = true, desc = 'Search Buffers' })
vim.keymap.set('n', '<Leader>sm', '<CMD>Pick manpages<CR>',                 { noremap = true, desc = 'Search Manpages' })
vim.keymap.set('n', '<Leader>sh', '<CMD>Pick help<CR>',                     { noremap = true, desc = 'Search Help' })
vim.keymap.set('n', '<Leader>sH', '<CMD>Pick hl_groups<CR>',                { noremap = true, desc = 'Search Highlights' })
vim.keymap.set('n', '<Leader>s:', '<CMD>Pick commands<CR>',                 { noremap = true, desc = 'Searc: Commands' })
vim.keymap.set('n', '<Leader>sc', '<CMD>Pick colorschemes<CR>',             { noremap = true, desc = 'Search Colorschemes' })
vim.keymap.set('n', '<Leader>sk', '<CMD>Pick keymaps<CR>',                  { noremap = true, desc = 'Search Keymaps' })
vim.keymap.set('n', '<Leader>sd', '<CMD>Pick diagnostic<CR>',               { noremap = true, desc = 'Search Diagnostic' })
vim.keymap.set('n', '<Leader>sp', '<CMD>Pick hipatterns<CR>',               { noremap = true, desc = 'Search Patterns' })
vim.keymap.set('n', '<Leader>sq', '<CMD>Pick list scope="quickfix"<CR>',    { noremap = true, desc = 'Search Quickfix' })
vim.keymap.set('n', '<Leader>sl', '<CMD>Pick list scope="location"<CR>',    { noremap = true, desc = 'Search Locations' })
vim.keymap.set('n', '<Leader>sj', '<CMD>Pick list scope="jump"<CR>',        { noremap = true, desc = 'Search Jumps' })
vim.keymap.set('n', '<Leader>sM', '<CMD>Pick marks<CR>',                    { noremap = true, desc = 'Search Marks' })
vim.keymap.set('n', '<Leader>sr', '<CMD>Pick registers<CR>',                { noremap = true, desc = 'Search Registers' })
vim.keymap.set('n', '<Leader>so', '<CMD>Pick options<CR>',                  { noremap = true, desc = 'Search Options' })

vim.keymap.set('n', '<Leader>ld', '<CMD>Pick lsp scope="definition"<CR>',       { noremap = true, desc = 'Search LSP Definition' })
vim.keymap.set('n', '<Leader>lD', '<CMD>Pick lsp scope="declaration"<CR>',      { noremap = true, desc = 'Search LSP Declaration' })
vim.keymap.set('n', '<Leader>ls', '<CMD>Pick lsp scope="document_symbol"<CR>',  { noremap = true, desc = 'Search LSP Symbols (Document)' })
vim.keymap.set('n', '<Leader>lS', '<CMD>Pick lsp scope="workspace_symbol"<CR>', { noremap = true, desc = 'Search LSP Symbols (Workspace)' })
vim.keymap.set('n', '<Leader>li', '<CMD>Pick lsp scope="implementation"<CR>',   { noremap = true, desc = 'Search LSP Implementation' })
vim.keymap.set('n', '<Leader>lr', '<CMD>Pick lsp scope="references"<CR>',       { noremap = true, desc = 'Search LSP Reference' })

vim.keymap.set('n', '<Leader>gf', '<CMD>Pick git_files<CR>',    { noremap = true, desc = 'Search Git Files' })
vim.keymap.set('n', '<Leader>gc', '<CMD>Pick git_commits<CR>',  { noremap = true, desc = 'Search Git Commits' })
vim.keymap.set('n', '<Leader>gb', '<CMD>Pick git_branches<CR>', { noremap = true, desc = 'Search Git Branches' })
vim.keymap.set('n', '<Leader>gh', '<CMD>Pick git_hunks<CR>',    { noremap = true, desc = 'Search Git Hunks' })

vim.keymap.set('n', '<Leader>ff',  function() files.open() end,                                     { noremap = true, desc = 'Files Open' })
vim.keymap.set('n', '<Leader>fr',  function() files.open(nil, false) end,                           { noremap = true, desc = 'Files Open Fresh' })
vim.keymap.set('n', '<Leader>flf', function() files.open(vim.api.nvim_buf_get_name(0)) end,         { noremap = true, desc = 'Files Open Local' })
vim.keymap.set('n', '<Leader>flr', function() files.open(vim.api.nvim_buf_get_name(0), false) end,  { noremap = true, desc = 'Files Open Local Fresh' })

vim.keymap.set('n', '<Leader>qq', function() sessions.read(vim.fn.input('Session: ', 'Session.vim')) end,   { noremap = true, desc = 'Session Read' })
vim.keymap.set('n', '<Leader>qw', function() sessions.write(vim.fn.input('Session: ', 'Session.vim')) end,  { noremap = true, desc = 'Session Write' })
vim.keymap.set('n', '<Leader>qs', function() sessions.select('read') end,                                   { noremap = true, desc = 'Session Select' })
vim.keymap.set('n', '<Leader>qr', function() sessions.restart() end,                                        { noremap = true, desc = 'Session Restart' })

vim.keymap.set('n', '<Leader>dq', '<CMD>lua vim.diagnostic.setqflist()<CR>',    { noremap = true, silent = true, desc = 'Diagnostic Quickfix' })
vim.keymap.set('n', '<Leader>dl', '<CMD>lua vim.diagnostic.setloclist()<CR>',   { noremap = true, silent = true, desc = 'Diagnostic Locations' })

vim.keymap.set('n', '<Esc>', '<CMD>nohlsearch<CR>', { noremap = true })

vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*",
    callback = function(_)
        if vim.lsp.buf_is_attached() then
            vim.lsp.buf.format()
        end
    end,
})
