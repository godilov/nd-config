local palette = {
    {
        white   = { '#FFFFFF', '#F2F2F2', '#E6E6E6', '#D9D9D9', '#CCCCCC', '#BFBFBF' },
        red     = { '#FFCCCC', '#FFB3B3', '#FF9999', '#FF8080' }, -- exec
        yellow  = { '#FFE6CC', '#FFD9B3', '#FFCC99', '#FFBF80' }, -- struct
        green   = { '#FFFFCC', '#FFFFB3', '#FFFF99', '#FFFF80' }, -- literal
        cyan    = { '#CCFFFF', '#B3FFFF', '#99FFFF', '#80FFFF' }, -- -
        blue    = { '#CCE6FF', '#B3D9FF', '#99CCFF', '#80BFFF' }, -- keyword
        magenta = { '#FFCCE6', '#FFB3D9', '#FF99CC', '#FF80BF' }, -- -
    },
    {
        black   = { '#000000', '#0D0D0D', '#1A1A1A', '#262626', '#333333', '#404040' },
        red     = { '#330000', '#4D0000', '#660000', '#800000' },
        yellow  = { '#331A00', '#4D2600', '#663300', '#804000' },
        green   = { '#333300', '#4C4D00', '#666600', '#7F8000' },
        cyan    = { '#003333', '#004C4D', '#006666', '#007F80' },
        blue    = { '#001933', '#00264D', '#003366', '#004080' },
        magenta = { '#33001A', '#4D0026', '#660033', '#800040' },
    },
}

local diag = {
    error = { fg = palette[1].red[4] },
    warn  = { fg = palette[1].yellow[4] },
    hint  = { fg = palette[1].green[4] },
    info  = { fg = palette[1].blue[4] },
    ok    = { fg = palette[1].white[1] },

    ul    = {
        error = { sp = palette[1].red[4], underline = true },
        warn  = { sp = palette[1].yellow[4], underline = true },
        hint  = { sp = palette[1].green[4], underline = true },
        info  = { sp = palette[1].blue[4], underline = true },
        ok    = { sp = palette[1].white[1], underline = true },
    },

    virt  = {
        error = { fg = palette[1].red[4] },
        warn  = { fg = palette[1].yellow[4] },
        hint  = { fg = palette[1].green[4] },
        info  = { fg = palette[1].blue[4] },
        ok    = { fg = palette[1].white[1] },
    },
}

local status = {
    error = { fg = palette[1].red[4] },
    warn  = { fg = palette[1].yellow[4] },
    info  = { fg = palette[1].green[4] },
    note  = { fg = palette[1].blue[4] },
}

local spell = {
    bad  = { sp = palette[1].red[3], underline = true },
    cap  = { sp = palette[1].yellow[3], underline = true },
    loc  = { sp = palette[1].green[3], underline = true },
    rare = { sp = palette[1].blue[3], underline = true },
}

local diff = {
    add = { fg = palette[1].green[3] },
    mod = { fg = palette[1].yellow[3] },
    rem = { fg = palette[1].red[3] },
}

local markdown = {
    fg = {
        ['heading'] = { fg = palette[1].white[1], bold = true },
        ['heading.1'] = { fg = palette[1].red[2], bold = true },
        ['heading.2'] = { fg = palette[1].yellow[2], bold = true },
        ['heading.3'] = { fg = palette[1].green[2], bold = true },
        ['heading.4'] = { fg = palette[1].cyan[1], bold = true },
        ['heading.5'] = { fg = palette[1].blue[1], bold = true },
        ['heading.6'] = { fg = palette[1].magenta[1], bold = true },
    },
    bg = {
        ['heading'] = { bg = palette[2].black[4] },
        ['heading.1'] = { bg = palette[2].red[1] },
        ['heading.2'] = { bg = palette[2].yellow[1] },
        ['heading.3'] = { bg = palette[2].green[1] },
        ['heading.4'] = { bg = palette[2].cyan[1] },
        ['heading.5'] = { bg = palette[2].blue[1] },
        ['heading.6'] = { bg = palette[2].magenta[1] },
    },
}

local editor = {
    normal     = { fg = palette[1].white[1], bg = palette[2].black[1] },
    invisible  = { fg = palette[2].black[1], bg = palette[2].black[1] },
    whitespace = { fg = palette[2].black[6] },
    select     = { bg = palette[2].black[6] },
    cursor     = { reverse = true },
    cursorx    = { bg = palette[2].black[3] },
    menu       = { fg = palette[1].white[1], bg = palette[2].black[3] },
    menusel    = { fg = palette[2].black[1], bg = palette[1].yellow[2] },
    search     = { fg = palette[2].black[1], bg = palette[1].yellow[2] },
    searchsel  = { fg = palette[2].black[1], bg = palette[1].red[2] },
    number     = { fg = palette[1].yellow[1] },
    numbersel  = { fg = palette[1].yellow[1], bold = true },
}

local syntax = {
    ['variable']            = { fg = palette[1].white[1] },
    ['constant']            = { fg = palette[1].white[1] },

    ['module']              = { fg = palette[1].yellow[1] },
    ['label']               = { fg = palette[1].yellow[1] },

    ['literal']             = { fg = palette[1].green[2] },
    ['literal.special']     = { fg = palette[1].yellow[2] },
    ['literal.escape']      = { fg = palette[1].green[2], bold = true },
    ['literal.regexp']      = { fg = palette[1].yellow[2] },
    ['literal.url']         = { fg = palette[1].yellow[2], underline = true },

    ['type']                = { fg = palette[1].yellow[3] },
    ['attribute']           = { fg = palette[1].yellow[2] },
    ['property']            = { fg = palette[1].yellow[2] },

    ['function']            = { fg = palette[1].red[3] },

    ['constructor']         = { fg = palette[1].yellow[3] },
    ['operator']            = { fg = palette[1].white[1] },

    ['keyword']             = { fg = palette[1].blue[1] },

    ['punctuation']         = { fg = palette[1].white[1] },
    ['punctuation.special'] = { fg = palette[1].yellow[3] },

    ['comment']             = { fg = palette[1].white[6] },
    ['comment.error']       = status.error,
    ['comment.warning']     = status.warn,
    ['comment.todo']        = status.info,
    ['comment.note']        = status.note,
}

local editor_hls = {
    { 'Normal',                     editor.normal },
    { 'NormalNC',                   editor.normal },
    { 'NormalFloat',                editor.normal },

    { 'Cursor',                     editor.cursor },
    { 'lCursor',                    editor.cursor },
    { 'CursorIM',                   editor.cursor },
    { 'TermCursor',                 editor.cursor },
    { 'TermCursorNC',               editor.cursor },

    { 'Visual',                     editor.select },
    { 'VisualNOS',                  editor.select },
    { 'Search',                     editor.search },
    { 'CurSearch',                  editor.searchsel },
    { 'IncSearch',                  editor.searchsel },
    { 'Substitute',                 editor.searchsel },

    { 'MsgArea',                    editor.normal },
    { 'MsgSeparator',               editor.normal },
    { 'ErrorMsg',                   status.error },
    { 'WarningMsg',                 status.warn },
    { 'ModeMsg',                    status.info },
    { 'MoreMsg',                    status.note },

    { 'Pmenu',                      editor.menu },
    { 'PmenuSel',                   editor.menusel },
    { 'PmenuKind',                  editor.menu },
    { 'PmenuKindSel',               editor.menusel },
    { 'PmenuExtra',                 editor.menu },
    { 'PmenuExtraSel',              editor.menusel },
    { 'PmenuSbar',                  editor.menu },
    { 'PmenuThumb',                 editor.menusel },
    { 'WildMenu',                   editor.menu },

    { 'FloatTitle',                 editor.normal },
    { 'FloatBorder',                editor.normal },
    { 'FloatFooter',                editor.normal },

    { 'SignColumn',                 editor.normal },
    { 'FoldColumn',                 editor.normal },
    { 'ColorColumn',                editor.cursorx },
    { 'CursorColumn',               editor.cursorx },
    { 'CursorLine',                 editor.cursorx },
    { 'Folded',                     editor.cursorx },
    { 'EndOfBuffer',                editor.invisible },
    { 'WinSeparator',               editor.invisible },

    { 'LineNr',                     editor.numbersel },
    { 'LineNrAbove',                editor.number },
    { 'LineNrBelow',                editor.number },
    { 'CursorLineNr',               editor.numbersel },
    { 'CursorLineFold',             editor.normal },
    { 'CursorLineSign',             editor.normal },
    { 'QuickFixLine',               editor.cursorx },

    { 'StatusLine',                 editor.normal },
    { 'StatusLineNC',               editor.normal },
    { 'TabLine',                    editor.cursorx },
    { 'TabLineFill',                editor.cursorx },
    { 'TabLineSel',                 editor.cursor },

    { 'DiffAdd',                    diff.add },
    { 'DiffChange',                 diff.mod },
    { 'DiffDelete',                 diff.rem },
    { 'DiffText',                   diff.mod },

    { 'SpecialKey',                 editor.whitespace },
    { 'Whitespace',                 editor.whitespace },
    { 'NonText',                    editor.whitespace },
    { 'Conceal',                    editor.whitespace },

    { 'SpellBad',                   spell.bad },
    { 'SpellCap',                   spell.cap },
    { 'SpellLocal',                 spell.loc },
    { 'SpellRare',                  spell.rare },

    { 'MatchParen',                 { fg = palette[1].red[3] } },
    { 'Directory',                  { fg = palette[1].yellow[2] } },
    { 'Title',                      { fg = palette[1].yellow[2] } },
    { 'Question',                   { fg = palette[1].yellow[2] } },
    { 'WinBar',                     { fg = palette[1].white[1], bg = palette[2].black[5], bold = true } },
    { 'WinBarNC',                   { fg = palette[1].white[1], bg = palette[2].black[5], bold = true } },
    { 'SnippetTabstop',             { fg = palette[1].white[1], bg = palette[2].black[5] } },

    { 'DiagnosticError',            diag.error },
    { 'DiagnosticWarn',             diag.warn },
    { 'DiagnosticHint',             diag.hint },
    { 'DiagnosticInfo',             diag.info },
    { 'DiagnosticOk',               diag.ok },

    { 'DiagnosticVirtualTextError', diag.virt.error },
    { 'DiagnosticVirtualTextWarn',  diag.virt.warn },
    { 'DiagnosticVirtualTextHint',  diag.virt.hint },
    { 'DiagnosticVirtualTextInfo',  diag.virt.info },
    { 'DiagnosticVirtualTextOk',    diag.virt.ok },

    { 'DiagnosticUnderlineError',   diag.ul.error },
    { 'DiagnosticUnderlineWarn',    diag.ul.warn },
    { 'DiagnosticUnderlineHint',    diag.ul.hint },
    { 'DiagnosticUnderlineInfo',    diag.ul.info },
    { 'DiagnosticUnderlineOk',      diag.ul.ok },
}

local syntax_hls = {
    { 'Comment',        syntax['comment'] },

    { 'Constant',       syntax['constant'] },
    { 'String',         syntax['literal'] },
    { 'Character',      syntax['literal'] },
    { 'Number',         syntax['literal'] },
    { 'Boolean',        syntax['literal'] },
    { 'Float',          syntax['literal'] },

    { 'Identifier',     syntax['variable'] },
    { 'Function',       syntax['function'] },

    { 'Statement',      syntax['keyword'] },
    { 'Conditional',    syntax['keyword'] },
    { 'Repeat',         syntax['keyword'] },
    { 'Label',          syntax['keyword'] },
    { 'Operator',       syntax['operator'] },
    { 'Keyword',        syntax['keyword'] },
    { 'Exception',      syntax['keyword'] },

    { 'PreProc',        syntax['function'] },
    { 'Include',        syntax['keyword'] },
    { 'Define',         syntax['keyword'] },
    { 'Macro',          syntax['keyword'] },
    { 'PreCondit',      syntax['keyword'] },

    { 'Type',           syntax['type'] },
    { 'StorageClass',   syntax['type'] },
    { 'Structure',      syntax['type'] },
    { 'Typedef',        syntax['type'] },

    { 'Special',        syntax['literal.special'] },
    { 'SpecialChar',    syntax['literal.special'] },
    { 'Tag',            syntax['literal'] },
    { 'Delimiter',      syntax['literal'] },
    { 'SpecialComment', syntax['literal'] },
    { 'Debug',          syntax['literal.special'] },

    { 'Underlined',     { fg = palette[1].white[1], underline = true } },

    { 'Error',          { fg = palette[1].red[4] } },

    { 'Todo',           syntax['comment.note'] },

    { 'Added',          diff.add },
    { 'Changed',        diff.mod },
    { 'Removed',        diff.rem },
}

local treesitter_hls = {
    { '@variable',                    syntax['variable'] },
    { '@variable.builtin',            syntax['variable'] },
    { '@variable.parameter',          syntax['variable'] },
    { '@variable.parameter.builtin',  syntax['variable'] },
    { '@variable.member',             syntax['variable'] },

    { '@constant',                    syntax['constant'] },
    { '@constant.builtin',            syntax['constant'] },
    { '@constant.macro',              syntax['constant'] },

    { '@module',                      syntax['module'] },
    { '@module.builtin',              syntax['module'] },
    { '@label',                       syntax['label'] },

    { '@string',                      syntax['literal'] },
    { '@string.documentation',        syntax['literal'] },
    { '@string.regexp',               syntax['literal.regexp'] },
    { '@string.escape',               syntax['literal.escape'] },
    { '@string.special',              syntax['literal.special'] },
    { '@string.special.symbol',       syntax['literal.special'] },
    { '@string.special.path',         syntax['literal.special'] },
    { '@string.special.url',          syntax['literal.url'] },

    { '@character',                   syntax['literal'] },
    { '@character.special',           syntax['literal.special'] },

    { '@boolean',                     syntax['literal'] },
    { '@number',                      syntax['literal'] },
    { '@number.float',                syntax['literal'] },

    { '@type',                        syntax['type'] },
    { '@type.builtin',                syntax['type'] },
    { '@type.definition',             syntax['type'] },

    { '@attribute',                   syntax['attribute'] },
    { '@attribute.builtin',           syntax['attribute'] },
    { '@property',                    syntax['property'] },

    { '@function',                    syntax['function'] },
    { '@function.builtin',            syntax['function'] },
    { '@function.call',               syntax['function'] },
    { '@function.macro',              syntax['function'] },

    { '@function.method',             syntax['function'] },
    { '@function.method.call',        syntax['function'] },

    { '@constructor',                 syntax['constructor'] },
    { '@operator',                    syntax['operator'] },

    { '@keyword',                     syntax['keyword'] },
    { '@keyword.coroutine',           syntax['keyword'] },
    { '@keyword.function',            syntax['keyword'] },
    { '@keyword.operator',            syntax['keyword'] },
    { '@keyword.import',              syntax['keyword'] },
    { '@keyword.type',                syntax['keyword'] },
    { '@keyword.modifier',            syntax['keyword'] },
    { '@keyword.repeat',              syntax['keyword'] },
    { '@keyword.return',              syntax['keyword'] },
    { '@keyword.debug',               syntax['keyword'] },
    { '@keyword.exception',           syntax['keyword'] },

    { '@keyword.conditional',         syntax['keyword'] },
    { '@keyword.conditional.ternary', syntax['keyword'] },

    { '@keyword.directive',           syntax['keyword'] },
    { '@keyword.directive.define',    syntax['keyword'] },

    { '@punctuation.delimiter',       syntax['punctuation'] },
    { '@punctuation.bracket',         syntax['punctuation'] },
    { '@punctuation.special',         syntax['punctuation.special'] },

    { '@comment',                     syntax['comment'] },
    { '@comment.documentation',       syntax['comment'] },
    { '@comment.error',               syntax['comment.error'] },
    { '@comment.warning',             syntax['comment.warning'] },
    { '@comment.todo',                syntax['comment.todo'] },
    { '@comment.note',                syntax['comment.note'] },

    { '@markup.strong',               { fg = palette[1].white[1], bold = true } },
    { '@markup.italic',               { fg = palette[1].white[1], italic = true } },
    { '@markup.strikethrough',        { fg = palette[1].white[1], strikethrough = true } },
    { '@markup.underline',            { fg = palette[1].white[1], underline = true } },

    { '@markup.heading',              markdown.fg['heading'] },
    { '@markup.heading.1',            markdown.fg['heading.1'] },
    { '@markup.heading.2',            markdown.fg['heading.2'] },
    { '@markup.heading.3',            markdown.fg['heading.3'] },
    { '@markup.heading.4',            markdown.fg['heading.4'] },
    { '@markup.heading.5',            markdown.fg['heading.5'] },
    { '@markup.heading.6',            markdown.fg['heading.6'] },

    { '@markup.quote',                { fg = palette[1].white[1] } },
    { '@markup.math',                 { fg = palette[1].yellow[2] } },

    { '@markup.link',                 { fg = palette[1].yellow[3] } },
    { '@markup.link.label',           { fg = palette[1].red[3] } },
    { '@markup.link.url',             { fg = palette[1].yellow[3], underline = true } },

    { '@markup.raw',                  { fg = palette[1].yellow[2] } },
    { '@markup.raw.block',            { fg = palette[1].red[2] } },

    { '@markup.list',                 { fg = palette[1].yellow[2] } },
    { '@markup.list.checked',         { fg = palette[1].green[2] } },
    { '@markup.list.unchecked',       { fg = palette[1].red[2] } },

    { '@diff.plus',                   diff.add },
    { '@diff.minus',                  diff.rem },
    { '@diff.delta',                  diff.mod },

    { '@tag',                         { fg = palette[1].red[2] } },
    { '@tag.builtin',                 { fg = palette[1].green[2] } },
    { '@tag.attribute',               { fg = palette[1].yellow[2] } },
    { '@tag.delimiter',               { fg = palette[1].white[1] } },
}

local function set_editor_hls()
    for _, v in ipairs(editor_hls) do
        vim.api.nvim_set_hl(0, v[1], v[2])
    end
end

local function set_syntax_hls()
    for _, v in ipairs(syntax_hls) do
        vim.api.nvim_set_hl(0, v[1], v[2])
    end
end

local function set_treesitter_hls()
    for _, v in ipairs(treesitter_hls) do
        vim.api.nvim_set_hl(0, v[1], v[2])
    end
end

return {
    set_editor_hls     = set_editor_hls,
    set_syntax_hls     = set_syntax_hls,
    set_treesitter_hls = set_treesitter_hls,
}
