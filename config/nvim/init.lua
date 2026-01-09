local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'

if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
            { out,                            'WarningMsg' },
            { '\nPress any key to exit...' },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.diagnostic.config {
    signs = true,
    float = true,
    underline = true,
    severity_sort = true,
    update_in_insert = true,
    virtual_text = true,
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
        }
    }
})

vim.lsp.config('biome', {
    filetypes = { 'html', 'css', 'graphql', 'json', 'jsonc' }
})

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

local opt = vim.opt

opt.mouse = 'a'
opt.encoding = 'utf-8'
opt.spelllang = { 'en' }
opt.virtualedit = 'block'
opt.foldmethod = 'expr'
opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
opt.foldlevel = 100

opt.autowrite = true
opt.autowriteall = true
opt.autoindent = true
opt.number = true
opt.relativenumber = true
opt.cursorline = false
opt.cursorcolumn = false
opt.splitright = true
opt.splitbelow = true
opt.smartcase = true
opt.smartindent = true
opt.termguicolors = true
opt.smoothscroll = false
opt.confirm = true
opt.list = true
opt.gdefault = true
opt.undofile = true
opt.undolevels = 10000

opt.signcolumn = 'yes'
opt.showmode = false
opt.ruler = false

opt.laststatus = 3
opt.tabstop = 4
opt.softtabstop = 4
opt.expandtab = true
opt.shiftwidth = 4
opt.shiftround = true
opt.scrolloff = 0
opt.sidescrolloff = 0
opt.winminwidth = 8
opt.pumheight = 16
opt.timeoutlen = 250
opt.updatetime = 200

opt.clipboard = vim.env.SSH_TTY and '' or 'unnamedplus'

local keys = require 'config.keys'
local colors = require 'config.colors'

keys.set_keys()
colors.set_editor_hls()
colors.set_syntax_hls()

local function lsp_goto(next, severity)
    local sev = severity and vim.diagnostic.severity[severity] or nil

    return function()
        vim.diagnostic.jump { count = next and 1 or -1, float = true, severity = sev }
    end
end

local function notify_autoformat()
    vim.notify('Autoformat\n' ..
        '[' .. (vim.g.autoformat_disable and ' ' or 'X') .. '] - Global\n' ..
        '[' .. (vim.b.autoformat_disable and ' ' or 'X') .. '] - Local',
        vim.log.levels.INFO)
end

require 'lazy'.setup {
    defaults = {
        lazy = true,
    },
    spec = {
        { 'nvim-tree/nvim-web-devicons' },
        { 'nvim-lua/plenary.nvim' },
        { 'MunifTanjim/nui.nvim' },
        { 'nvim-neotest/nvim-nio' },
        { 'rcarriga/nvim-notify' },
        {
            'nvim-neo-tree/neo-tree.nvim',
            cmd = 'Neotree',
            dependencies = {
                'nvim-lua/plenary.nvim',
                'nvim-tree/nvim-web-devicons',
                'MunifTanjim/nui.nvim',
            },
            opts = {
                filesystem = {
                    filtered_items = {
                        visible = false,
                        hide_dotfiles = false,
                        hide_gitignored = false,
                        hide_hidden = false,
                    },
                }
            },
            keys = {
                {
                    '<leader>fe',
                    function()
                        require 'neo-tree.command'.execute { source = 'filesystem', position = 'float', toggle = true }
                    end,
                    desc = 'Explorer NeoTree (Float)'
                },
                {
                    '<leader>fE',
                    function()
                        require 'neo-tree.command'.execute { source = 'filesystem', position = 'left', toggle = true }
                    end,
                    desc = 'Explorer NeoTree (Attach)',
                },
                {
                    '<leader>ge',
                    function()
                        require 'neo-tree.command'.execute { source = 'git_status', position = 'float', toggle = true }
                    end,
                    desc = 'Git Explorer (Float)',
                },
                {
                    '<leader>gE',
                    function()
                        require 'neo-tree.command'.execute { source = 'git_status', position = 'left', toggle = true }
                    end,
                    desc = 'Git Explorer (Attach)',
                },
                {
                    '<leader>be',
                    function()
                        require 'neo-tree.command'.execute { source = 'buffers', position = 'float', toggle = true }
                    end,
                    desc = 'Buffer Explorer (Float)',
                },
                {
                    '<leader>bE',
                    function()
                        require 'neo-tree.command'.execute { source = 'buffers', position = 'left', toggle = true }
                    end,
                    desc = 'Buffer Explorer (Attach)',
                },
            },
        },
        {
            'ibhagwan/fzf-lua',
            lazy = false,
            cmd = 'FzfLua',
            dependencies = {
                'nvim-tree/nvim-web-devicons'
            },
            opts = {},
            keys = {
                { '<leader><space>', '<CMD>FzfLua files<CR>',           desc = 'Find Files' },
                { '<leader>/',       '<CMD>FzfLua live_grep<CR>',       desc = 'Find Live' },
                { '<leader>.',       '<CMD>FzfLua grep<CR>',            desc = 'Find Grep' },
                { '<leader>,',       '<CMD>FzfLua buffers<CR>',         desc = 'Find Buffer' },
                { '<leader>:',       '<CMD>FzfLua command_history<CR>', desc = 'Command History' },

                { '<leader>ff',      '<CMD>FzfLua files<CR>',           desc = 'Find Files' },
                { '<leader>fr',      '<CMD>FzfLua oldfiles<CR>',        desc = 'Find Recent' },
                { '<leader>fl',      '<CMD>FzfLua live_grep<CR>',       desc = 'Find Live' },
                { '<leader>fg',      '<CMD>FzfLua grep<CR>',            desc = 'Find Grep' },
                { '<leader>fb',      '<CMD>FzfLua buffers<CR>',         desc = 'Find Buffer' },

                { '<leader>sa',      '<CMD>FzfLua autocmds<CR>',        desc = 'Autocommands' },
                { '<leader>sc',      '<CMD>FzfLua commands<CR>',        desc = 'Commands' },
                { '<leader>sq',      '<CMD>FzfLua quickfix<CR>',        desc = 'Quickfix' },
                { '<leader>sC',      '<CMD>FzfLua command_history<CR>', desc = 'Command History' },
                { '<leader>sQ',      '<CMD>FzfLua quickfix_stack<CR>',  desc = 'Quickfix Stack' },
                { '<leader>sh',      '<CMD>FzfLua helptags<CR>',        desc = 'Help Pages' },
                { '<leader>sM',      '<CMD>FzfLua manpages<CR>',        desc = 'Man Pages' },
                { '<leader>sm',      '<CMD>FzfLua marks<CR>',           desc = 'Marks' },
                { '<leader>sj',      '<CMD>FzfLua jumps<CR>',           desc = 'Jumps' },
                { '<leader>sr',      '<CMD>FzfLua registers<CR>',       desc = 'Registers' },
                { '<leader>sH',      '<CMD>FzfLua highlights<CR>',      desc = 'Highlights' },
                { '<leader>ss',      '<CMD>FzfLua colorschemes<CR>',    desc = 'Colorschemes' },
                { '<leader>sk',      '<CMD>FzfLua keymaps<CR>',         desc = 'Keymaps' },
                { '<leader>sf',      '<CMD>FzfLua filetypes<CR>',       desc = 'Filetypes' },

                { '<leader>gf',      '<CMD>FzfLua git_files<CR>',       desc = 'Git Files' },
                { '<leader>gc',      '<CMD>FzfLua git_commits<CR>',     desc = 'Git Commits (Global)' },
                { '<leader>gC',      '<CMD>FzfLua git_bcommits<CR>',    desc = 'Git Commits (Local)' },
                { '<leader>gb',      '<CMD>FzfLua git_branches<CR>',    desc = 'Git Branches' },
                { '<leader>gs',      '<CMD>FzfLua git_status<CR>',      desc = 'Git Status' },
            },
            config = function(_, opts)
                local fzf = require 'fzf-lua'

                fzf.setup(opts)
                fzf.register_ui_select()
            end,
        },
        {
            'nvim-lualine/lualine.nvim',
            event = { 'VeryLazy' },
            opts = {
                options = {
                    theme = colors.get_lualine_hls(),
                    globalstatus = vim.o.laststatus == 3,
                    disabled_filetypes = {
                        statusline = {
                            'dashboard',
                            'alpha',
                            'ministarter',
                            'snacks_dashboard',
                        },
                    },
                },
                sections = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_c = {
                        { 'filesize' },
                        { 'filename', path = 4 },
                    },
                    lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' },
                },
                extensions = { 'neo-tree', 'lazy' },
            },
        },
        {
            'akinsho/bufferline.nvim',
            event = { 'VeryLazy' },
            opts = {
                options = {
                    diagnostics = 'nvim_lsp',
                    always_show_bufferline = false,
                    offsets = {
                        {
                            filetype = 'neo-tree',
                            text = 'Neo-tree',
                            highlight = 'Directory',
                            text_align = 'left',
                        },
                    },
                },
            },
            keys = {
                { '[b',         '<CMD>BufferLineCyclePrev<CR>',            desc = 'Prev Buffer' },
                { ']b',         '<CMD>BufferLineCycleNext<CR>',            desc = 'Next Buffer' },
                { '[B',         '<CMD>BufferLineMovePrev<CR>',             desc = 'Move Buffer prev' },
                { ']B',         '<CMD>BufferLineMoveNext<CR>',             desc = 'Move Buffer next' },

                { '<A-h>',      '<CMD>BufferLineCyclePrev<CR>',            desc = 'Prev Buffer' },
                { '<A-l>',      '<CMD>BufferLineCycleNext<CR>',            desc = 'Next Buffer' },
                { '<A-H>',      '<CMD>BufferLineMovePrev<CR>',             desc = 'Move Buffer prev' },
                { '<A-L>',      '<CMD>BufferLineMoveNext<CR>',             desc = 'Move Buffer next' },

                { '<leader>br', '<CMD>BufferLineCloseRight<CR>',           desc = 'Delete Buffers to the Right' },
                { '<leader>bl', '<CMD>BufferLineCloseLeft<CR>',            desc = 'Delete Buffers to the Left' },
                { '<leader>bp', '<CMD>BufferLineTogglePin<CR>',            desc = 'Toggle Pin' },
                { '<leader>bP', '<CMD>BufferLineGroupClose ungrouped<CR>', desc = 'Delete Non-Pinned Buffers' },
            },
        },
        {
            'folke/which-key.nvim',
            cmd = 'WhichKey',
            event = { 'VeryLazy' },
            opts = {
                spec = {
                    { '[',         group = 'Prev' },
                    { ']',         group = 'Next' },
                    { 'g',         group = 'Goto' },
                    { '<leader>',  group = 'Commands' },
                    { '<leader>b', group = 'Buffers' },
                    { '<leader>t', group = 'Tasks/Tabs' },
                    { '<leader>f', group = 'Files' },
                    { '<leader>s', group = 'Search' },
                    { '<leader>g', group = 'Git' },
                    { '<leader>e', group = 'Exec' },
                    { '<leader>d', group = 'Debug' },
                    { '<leader>c', group = 'Code/LSP' },
                    { '<leader>u', group = 'UI' },
                    { '<leader>n', group = 'Notifications' },
                    { '<leader>q', group = 'Session' },
                },
            },
            keys = {
                {
                    '<leader>?',
                    function()
                        require 'which-key'.show { global = false }
                    end,
                    desc = 'Keymaps Local',
                },
            },
        },
        {
            'folke/noice.nvim',
            lazy = false,
            dependencies = {
                'MunifTanjim/nui.nvim',
                'rcarriga/nvim-notify',
                'nvim-treesitter/nvim-treesitter',
            },
            opts = {},
            keys = {
                { '<leader>nh', '<CMD>Noice<CR>',         desc = 'History' },
                { '<leader>nd', '<CMD>Noice dismiss<CR>', desc = 'Dismiss' },
                { '<leader>ne', '<CMD>Noice errors<CR>',  desc = 'Errors' },
            },
            config = function(_, opts)
                require 'noice'.setup(opts)

                colors.set_notify_hls()
            end,
        },
        {
            'folke/snacks.nvim',
            lazy = false,
            opts = {
                dashboard = { enabled = true },
                words = { enabled = true },
                indent = {
                    enabled = true,
                    animate = { enabled = false },
                },
            },
            keys = {
                { '<C-/>', function() require 'snacks'.terminal() end, desc = 'Terminal Open', },
                { '<C-/>', '<CMD>close<CR>',                           desc = 'Terminal Close', mode = { 't' }, },
            },
        },
        {
            'folke/persistence.nvim',
            event = { 'BufReadPre' },
            opts = {},
            keys = {
                {
                    '<leader>ql',
                    function()
                        require 'persistence'.load()
                    end,
                    desc = 'Session Load',
                },
                {
                    '<leader>qL',
                    function()
                        require 'persistence'.load { last = true }
                    end,
                    desc = 'Session Load Last',
                },
                {
                    '<leader>qs',
                    function()
                        require 'persistence'.select()
                    end,
                    desc = 'Session Select',
                },
                {
                    '<leader>qd',
                    function()
                        require 'persistence'.stop()
                    end,
                    desc = 'Session Stop',
                },
            },
        },
        {
            'folke/trouble.nvim',
            cmd = 'Trouble',
            dependencies = {
                'neovim/nvim-lspconfig',
            },
            opts = {},
        },
        {
            'nvim-mini/mini.nvim',
            event = { 'VeryLazy' },
        },
        {
            'lewis6991/gitsigns.nvim',
            cmd = { 'Gitsigns' },
            event = { 'VeryLazy' },
            opts = {},
        },
        {
            'neovim/nvim-lspconfig',
            lazy = vim.fn.argc(-1) == 0,
            event = { 'VeryLazy' },
            dependencies = {
                'folke/snacks.nvim',
            },
            keys = {
                { '[d', lsp_goto(false),          desc = 'Prev Diagnostic' },
                { ']d', lsp_goto(true),           desc = 'Next Diagnostic' },
                { '[h', lsp_goto(false, 'HINT'),  desc = 'Prev Hint' },
                { ']h', lsp_goto(true, 'HINT'),   desc = 'Next Hint' },
                { '[i', lsp_goto(false, 'INFO'),  desc = 'Prev Info' },
                { ']i', lsp_goto(true, 'INFO'),   desc = 'Next Info' },
                { '[w', lsp_goto(false, 'WARN'),  desc = 'Prev Warning' },
                { ']w', lsp_goto(true, 'WARN'),   desc = 'Next Warning' },
                { '[e', lsp_goto(false, 'ERROR'), desc = 'Prev Error' },
                { ']e', lsp_goto(true, 'ERROR'),  desc = 'Next Error' },
                {
                    ']]',
                    function()
                        require 'snacks'.words.jump(vim.v.count1)
                    end,
                    desc = 'Next Reference',
                },
                {
                    '[[',
                    function()
                        require 'snacks'.words.jump(-vim.v.count1)
                    end,
                    desc = 'Prev Reference',
                },

                { 'gd',         '<CMD>FzfLua lsp_definitions<CR>',                                  desc = 'Goto Definition' },
                { 'gr',         '<CMD>FzfLua lsp_references<CR>',                                   desc = 'Goto References' },
                { 'gI',         '<CMD>FzfLua lsp_implementations<CR>',                              desc = 'Goto Implementation' },
                { 'gy',         '<CMD>FzfLua lsp_typedefs<CR>',                                     desc = 'Goto T[y]pe Definition' },
                { 'gD',         '<CMD>FzfLua lsp_declarations<CR>',                                 desc = 'Goto Declaration' },
                { 'K',          vim.lsp.buf.hover,                                                  desc = 'Hover', },
                { 'gK',         vim.lsp.buf.signature_help,                                         desc = 'Signature', },
                { '<C-\\>',     vim.lsp.buf.signature_help,                                         desc = 'Signature',             mode = { 'i' } },

                { '<leader>cl', '<CMD>LspInfo<CR>',                                                 desc = 'Lsp Info' },
                { '<leader>cs', '<CMD>FzfLua lsp_document_symbols<CR>',                             desc = 'Symbols (Local)' },
                { '<leader>cS', '<CMD>FzfLua lsp_workspace_symbols<CR>',                            desc = 'Symbols (Global)' },
                { '<leader>cd', '<CMD>FzfLua lsp_document_diagnostics<CR>',                         desc = 'Diagnostics (Local)' },
                { '<leader>cD', '<CMD>FzfLua lsp_workspace_diagnostics<CR>',                        desc = 'Diagnostics (Global)' },
                { '<leader>cq', '<CMD>Trouble diagnostics toggle auto_close=true filter.buf=0<CR>', desc = 'Diagnostics (Local)' },
                { '<leader>cQ', '<CMD>Trouble diagnostics toggle auto_close=true <CR>',             desc = 'Diagnostics (Global)' },
                { '<leader>ca', '<CMD>FzfLua lsp_code_actions<CR>',                                 desc = 'Code Action',           mode = { 'n', 'v' } },
                { '<leader>ci', '<CMD>FzfLua lsp_incoming_calls<CR>',                               desc = 'Incoming Calls' },
                { '<leader>co', '<CMD>FzfLua lsp_outgoing_calls<CR>',                               desc = 'Outcoming Calls' },
                { '<leader>cx', vim.diagnostic.open_float,                                          desc = 'Line Diagnostics' },
                { '<leader>cr', vim.lsp.buf.rename,                                                 desc = 'Rename' },
                {
                    '<leader>cR',
                    function()
                        require 'snacks'.rename.rename_file()
                    end,
                    desc = 'Rename File',
                },
                {
                    '<leader>cth',
                    function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end,
                    desc = 'Toggle Inlay Hints',
                },
                {
                    '<leader>ctd',
                    function()
                        vim.diagnostic.enable(not vim.diagnostic.is_enabled())
                    end,
                    desc = 'Toggle Diagnsotic',
                },
            },
        },
        {
            'nvim-treesitter/nvim-treesitter',
            build = ':TSUpdate',
            cmd = { 'TSUpdate', 'TSInstall' },
            event = { 'VeryLazy' },
            opts = {
                ensure_installed = {
                    'c',
                    'cpp',
                    'asm',
                    'rust',
                    'solidity',
                    'bash',
                    'lua',
                    'query',
                    'cmake',
                    'dockerfile',
                    'cuda',
                    'glsl',
                    'proto',
                    'sql',
                    'html',
                    'css',
                    'scss',
                    'regex',
                    'javascript',
                    'typescript',
                    'json',
                    'yaml',
                    'toml',
                    'diff',
                    'git_config',
                    'git_rebase',
                    'gitattributes',
                    'gitcommit',
                    'gitignore',
                    'hyprlang',
                    'yuck',
                    'markdown',
                    'markdown_inline',
                    'typst',
                },
                highlight = { enable = true },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = '<C-Space>',
                        node_incremental = '<C-Space>',
                        scope_incremental = '<A-Space>',
                        node_decremental = '<BS>',
                    },
                },
                textobjects = {
                    move = {
                        enable = true,
                        goto_next_start = {
                            [']f'] = '@function.outer',
                            [']c'] = '@class.outer',
                            [']a'] = '@parameter.inner',
                        },
                        goto_next_end = {
                            [']F'] = '@function.outer',
                            [']C'] = '@class.outer',
                            [']A'] = '@parameter.inner',
                        },
                        goto_previous_start = {
                            ['[f'] = '@function.outer',
                            ['[c'] = '@class.outer',
                            ['[a'] = '@parameter.inner',
                        },
                        goto_previous_end = {
                            ['[F'] = '@function.outer',
                            ['[C'] = '@class.outer',
                            ['[A'] = '@parameter.inner',
                        },
                    },
                },
            },
            keys = {
                { '[f', desc = 'Prev Function Start' },
                { '[c', desc = 'Prev Class Start' },
                { '[a', desc = 'Prev Paramater Start' },
                { '[F', desc = 'Prev Function End' },
                { '[C', desc = 'Prev Class End' },
                { '[A', desc = 'Prev Paramater End' },

                { ']f', desc = 'Next Function Start' },
                { ']c', desc = 'Next Class Start' },
                { ']a', desc = 'Next Paramater Start' },
                { ']F', desc = 'Next Function End' },
                { ']C', desc = 'Next Class End' },
                { ']A', desc = 'Next Paramater End' },
            },
            config = function(_, opts)
                require 'nvim-treesitter.configs'.setup(opts)

                colors.set_treesitter_hls()
            end
        },
        {
            'nvim-treesitter/nvim-treesitter-textobjects',
            event = { 'VeryLazy' },
            dependencies = {
                'nvim-treesitter/nvim-treesitter',
            },
            opts = {},
            config = function() end,
        },
        {
            'stevearc/conform.nvim',
            cmd = { 'ConformInfo' },
            event = { 'BufWritePre' },
            opts = {
                formatters = {
                    injected = {
                        options = {
                            default_edition = '2024',
                        }
                    },
                },
                formatters_by_ft = {
                    json = { 'jq', 'injected' },
                    markdown = { 'prettier', 'injected' },
                },
                default_format_opts = {
                    lsp_format = 'fallback',
                },
                format_on_save = function(bufnr)
                    if not vim.g.autoformat_disable and not vim.b[bufnr].autoformat_disable then
                        return { timeout_ms = 1000, lsp_format = 'fallback' }
                    end
                end,
            },
            keys = {
                {
                    '<leader>cf',
                    function()
                        require 'conform'.format { async = true }
                    end,
                    desc = 'Format',
                },
                {
                    '<leader>ctf',
                    function()
                        vim.g.autoformat_disable = not vim.g.autoformat_disable

                        notify_autoformat()
                    end,
                    desc = 'Toggle Autoformat (Global)',
                },
                {
                    '<leader>ctF',
                    function()
                        vim.b.autoformat_disable = not vim.b.autoformat_disable

                        notify_autoformat()
                    end,
                    desc = 'Toggle Autoformat (Local)',
                },
            },
        },
        {
            'rcarriga/nvim-dap-ui',
            event = { 'BufRead' },
            dependencies = {
                'nvim-neotest/nvim-nio',
                'mfussenegger/nvim-dap',
            },
            opts = {},
            config = function(_, opts)
                local dap = require 'dap'
                local dapui = require 'dapui'

                dap.listeners.before.attach.dapui_config = function()
                    dapui.open()
                end

                dap.listeners.before.launch.dapui_config = function()
                    dapui.open()
                end

                dap.listeners.before.event_terminated.dapui_config = function()
                    dapui.close()
                end

                dap.listeners.before.event_exited.dapui_config = function()
                    dapui.close()
                end

                dapui.setup(opts)
            end,
        },
        {
            'mfussenegger/nvim-dap',
            keys = {
                { '<leader>dss', '<CMD>DapNew<CR>',              desc = 'Debug Start Session' },
                { '<leader>dsp', '<CMD>DapDisconnect<CR>',       desc = 'Debug Pause Session' },
                { '<leader>dsc', '<CMD>DapContinue<CR>',         desc = 'Debug Continue Session' },
                { '<leader>dse', '<CMD>DapTerminate<CR>',        desc = 'Debug End Session' },
                { '<leader>dt',  '<CMD>DapToggleBreakpoint<CR>', desc = 'Debug Toggle Breakpoint' },
                { '<leader>dc',  '<CMD>DapClearBreakpoints<CR>', desc = 'Debug Clear Breakpoint' },
                { '<leader>de',  '<CMD>DapEval<CR>',             desc = 'Debug Eval' },
                { '<leader>dr',  '<CMD>DapToggleRepl<CR>',       desc = 'Debug Repl' },
            },
            config = function(_, _)
                local dap = require 'dap'

                dap.adapters.codelldb = {
                    type = 'executable',
                    command = 'codelldb',
                }
            end,
        },
        {
            'stevearc/overseer.nvim',
            event = { 'BufRead' },
            opts = {},
            keys = {
                { '<leader>ti', '<CMD>OverseerInfo<CR>',   desc = 'Tasks Info' },
                { '<leader>tt', '<CMD>OverseerToggle<CR>', desc = 'Tasks Toggle' },
                { '<leader>tr', '<CMD>OverseerRun<CR>',    desc = 'Tasks Run' },
            },
        },
        {
            'Saecki/crates.nvim',
            event = { 'BufRead Cargo.toml' },
            opts = {},
        },
        {
            'folke/lazydev.nvim',
            ft = 'lua',
            opts = {
                library = {
                    {
                        path = '${3rd}/luv/library',
                        words = { 'vim%.uv' },
                    },
                },
            },
        },
        {
            'MeanderingProgrammer/render-markdown.nvim',
            ft = 'markdown',
            dependencies = {
                'nvim-tree/nvim-web-devicons',
                'nvim-treesitter/nvim-treesitter',
            },
            opts = {},
            config = function(_, opts)
                require 'render-markdown'.setup(opts)

                colors.set_markdown_hls()
            end
        },
        {
            'chomosuke/typst-preview.nvim',
            ft = 'typst',
            opts = {},
        },
        {
            'saghen/blink.cmp',
            build = 'cargo build --release',
            event = 'InsertEnter',
            opts_extend = { 'sources.default' },
            opts = {
                keymap = {
                    preset = 'none',

                    ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },

                    ['<CR>'] = { 'accept', 'fallback' },

                    ['<C-k>'] = { 'select_prev', 'fallback' },
                    ['<C-j>'] = { 'select_next', 'fallback' },

                    ['<C-u>'] = { 'scroll_documentation_up', 'fallback' },
                    ['<C-d>'] = { 'scroll_documentation_down', 'fallback' },
                },
                sources = {
                    default = { 'lsp', 'path', 'buffer', 'markdown', 'lazydev' },
                    providers = {
                        lazydev = {
                            name = 'LazyDev',
                            module = 'lazydev.integrations.blink',
                            score_offset = 100,
                        },
                        markdown = {
                            name = 'RenderMarkdown',
                            module = 'render-markdown.integ.blink',
                            fallbacks = { 'lsp' },
                        },
                    },
                },
            },
        },
        {
            'norcalli/nvim-colorizer.lua',
            ft = { 'html', 'css', 'lua', 'toml', 'yaml' },
            opts = {
                'html',
                'css',
                'lua',
                'toml',
                'yaml',
            },
        },
    },
    checker = { enabled = true },
}
