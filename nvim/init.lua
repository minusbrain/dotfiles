-- Core configuration
vim.opt.encoding = "utf8"
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = false
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.swapfile = false
vim.opt.clipboard = "unnamedplus"
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.completeopt = { "menu", "menuone", "noselect"}
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.fixendofline = false
vim.opt.title = true
vim.opt.list = true
vim.opt.background = "dark"

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  command = [[%s/\s\+$//e]],
})

-----------------
-- lazy.nvim
-----------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  { "nvim-treesitter/nvim-treesitter" },
  { "tpope/vim-fugitive" },
  { "tpope/vim-commentary" },
  { "itchyny/vim-cursorword" },
  { "neovim/nvim-lspconfig" },
  { "onsails/lspkind-nvim" },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    }
  },
  {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local rg_opts = ""
      local config_dir = vim.fn.stdpath("config")
      rg_opts = rg_opts .. " --vimgrep --column --line-number --no-heading"
      rg_opts = rg_opts .. " --color=always --smart-case --max-columns=4096"
      rg_opts = rg_opts .. " --vim-esc --no-ignore-parent"
      local rg_cmd = string.format('%s/vrg rg%s', config_dir, rg_opts)
      require("fzf-lua").setup({
        grep = {
          cmd = rg_cmd,
          rg_glob = false,
        },
        nbsp = '\xc2\xa0',
        file_icon_padding = ' ',
      })

      vim.keymap.set("n", "<space>f", "<cmd>lua require('fzf-lua').files({ cmd = 'rg --files' })<CR>", { silent = true })
      vim.keymap.set("n", "<space>h", "<cmd>lua require('fzf-lua').command_history()<CR>", { silent = true })
      vim.keymap.set("n", "<space>c", "<cmd>lua require('fzf-lua').commands()<CR>", { silent = true })
      vim.keymap.set("n", "<space>b", "<cmd>lua require('fzf-lua').buffers()<CR>", { silent = true })
      vim.keymap.set("n", "<space>j", "<cmd>lua require('fzf-lua').jumps()<CR>", { silent = true })
      vim.keymap.set("n", "<space>rb", "<cmd>lua require('fzf-lua').lgrep_curbuf()<CR>", { silent = true })
      vim.keymap.set("n", "<space>rr", "<cmd>lua require('fzf-lua').live_grep()<CR>", { silent = true })
      vim.keymap.set("n", "<space>rw", "<cmd>lua require('fzf-lua').live_grep({ search = vim.fn.expand('<cword>') })<CR>", { silent = true })
      vim.keymap.set("n", "<space>rp", "<cmd>lua require('fzf-lua').live_grep_resume()<CR>", { silent = true })

      vim.keymap.set('n', '<Space>a', function()
        local fn = vim.fn.expand('%:t:r')
        local ext = vim.fn.expand('%:t:e')
        local query = string.format("\"%s !.%s$\"", fn, ext)
        require'fzf-lua'.files({fzf_opts = {['--exact -1 --query'] = query}, cmd="rg --files"})
      end)
    end
  },
  {
    "vim-airline/vim-airline",
    dependencies = {
      "vim-airline/vim-airline-themes",
      "edkolev/tmuxline.vim",
    },
    init = function()
      vim.g.airline_theme='google_dark'
    end,
  },
  {
    "morhetz/gruvbox",
    init = function()
      vim.cmd.colorscheme("gruvbox")
    end,
  },
  {
    "sirver/ultisnips",
    init = function()
      vim.g.UltiSnipsJumpForwardTrigger = '<Tab>'
      vim.g.UltiSnipsJumpBackwardTrigger = '<S-Tab>'
    end
  },
  {
    "honza/vim-snippets"
  },
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "quangnguyen30192/cmp-nvim-ultisnips",
    }
  },
  { "zbirenbaum/copilot.lua" },
  {
  "zbirenbaum/copilot-cmp",
    config = function ()
      require("copilot_cmp").setup()
    end
  },
  {
    "kassio/neoterm",
    init = function()
      vim.g.neoterm_automap_keys = '<space>tt'
    end,
  },
})

----------
-- NeoTree
----------
require("neo-tree").setup({
  close_if_last_window = false,
  enable_diagnostics = false,
  enable_git_status = true,
  popup_border_style = "rounded",
  default_component_configs = {
    container = {
      enable_character_fade = true
    },
    indent = {
      indent_size = 2,
      padding = 1, -- extra padding on left hand side
      -- indent guides
      with_markers = true,
      indent_marker = "│",
      last_indent_marker = "└",
      highlight = "NeoTreeIndentMarker",
      -- expander config, needed for nesting files
      with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
      expander_collapsed = "",
      expander_expanded = "",
      expander_highlight = "NeoTreeExpander",
    },
    icon = {
      folder_closed = "",
      folder_open = "",
      folder_empty = "󰜌",
      default = "",
      highlight = "NeoTreeFileIcon"
    },
  },
  window = {
    position = "current",
    mappings = {
      ["/"] = "noop",
      ["y"] = "noop",
      ["x"] = "close_node",
      ["<space>"] = "noop",
      ["z"] = "noop",
      ["l"] = "noop",
      ["o"] = "open",
      ["oc"] = "noop",
      ["od"] = "noop",
      ["og"] = "noop",
      ["om"] = "noop",
      ["on"] = "noop",
      ["os"] = "noop",
      ["ot"] = "noop",
      ["yn"] = {
        function(state)
          vim.cmd(string.format("let @+='%s'", state.tree:get_node().name))
          print(string.format("Copied %s to clipboard", state.tree:get_node().name))
        end,
        desc = "yank_file_name",
      },
      ["yp"] = {
        function(state)
          vim.cmd(string.format("let @+='%s'", state.tree:get_node().path))
          print(string.format("Copied %s to clipboard", state.tree:get_node().path))
        end,
        desc = "yank_file_path",
      },
    }
  },
  filesystem = {
    visible = false,
    hide_dotfiles = false,
    hide_gitignored = false,
    use_libuv_file_watcher = true,
    follow_current_file = {
      enabled = true,
      leave_dirs_open = true
    },
    filtered_items = {
      always_show = {
        ".gitignore",
        ".gitlab-ci.yml",
        ".gitattributes",
	".config"
      },
      hide_by_name = {
        "__init__.py",
        "__pycache__",
      },
    }
  }
})

vim.keymap.set('n', '<Space>e', '<cmd>Neotree reveal left<cr>')

--------------------
-- plugin cursorword
--------------------
vim.g.cursorword_delay = 800
vim.g.cursorwordu = 0

------------------
-- plugin nvim-cmp
------------------
local cmp = require('cmp')
local types = require('cmp.types')

cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["UltiSnips#Anon"](args.body)
    end,
  },
  experimental = {
     ghost_text = { hl_group = 'CmpGhostText' }
  },
  window = {
  },
  formatting = {
    format = require("lspkind").cmp_format({
      mode = "symbol_text",
      symbol_map = {
        Text = "󰉿",
        Method = "󰆧",
        Function = "󰊕",
        Constructor = "匧",
        Field = "󰜢",
        Variable = "󰀫",
        Class = "󰠱",
        Interface = "",
        Module = "䠋",
        Property = "󰜢",
        Unit = "󰑭",
        Value = "󰎠",
        Enum = "",
        Keyword = "󰌋",
        Snippet = "䟕",
        Color = "󰏘",
        File = "󰈙",
        Reference = "󰈇",
        Folder = "󰉋",
        EnumMember = "",
        Constant = "󰏿",
        Struct = "󰙅",
        Event = "",
        Operator = "󰆕",
        TypeParameter = "",
        Copilot = "",
      }
    })
  },
  completion = {
    autocomplete = false,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-a>'] = cmp.mapping.complete(),
    ['<tab>'] = cmp.mapping.confirm({ select = true }),
    ['<C-e>'] = cmp.mapping.abort(),
  }),
  sources = {
    {
      name = 'path',
      option = {
        trailing_slash = true
      },
    },
    { name = 'ultisnips' },
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  completion = {
    autocomplete = {
      types.cmp.TriggerEvent.TextChanged,
    },
  },
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    {
      name = 'cmdline',
    },
  })
})

-- Set configuration for lsp languages.
cmp.setup.filetype({'lua', 'rust', 'python', 'cpp', 'c'}, {
  completion = {
    autocomplete = false
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'copilot' },
    { name = 'ultisnips' },
    { name = 'path' },
  })
})

-- LSP configuration
local function lspSymbol(name, icon)
  vim.fn.sign_define('DiagnosticSign' .. name,
    { text = icon, texthl = 'DiagnosticSign' .. name }
  )
end

lspSymbol('Error', '')
lspSymbol('Warn', '')
lspSymbol('Info', '')
lspSymbol('Hint', '')

local on_attach = function(_, bufnr)
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  vim.keymap.set('n', 'gf', vim.lsp.buf.format, bufopts)
  vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  -- vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
end

local cap_lsp = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())

require('lspconfig').rust_analyzer.setup {
  capabilities = cap_lsp,
  on_attach = on_attach
}

require('lspconfig').clangd.setup {
  capabilities = cap_lsp,
  on_attach = on_attach
}

require('lspconfig').lua_ls.setup {
  on_attach = on_attach,
  capabilities = cap_lsp,
-- See https://github.com/LuaLS/lua-language-server/wiki/Settings
  settings = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
      },
      diagnostics = {
        globals = { 'vim', 'string' },
      },
      workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

require('lspconfig')['pyright'].setup {
  capabilities = cap_lsp,
  on_attach = on_attach
}

vim.api.nvim_set_hl(0, "@lsp.type.namespace.rust", { link = "Default" })
vim.api.nvim_set_hl(0, "@lsp.type.interface.rust", { link = "csClass" })
vim.api.nvim_set_hl(0, "@lsp.type.struct.rust", { link = "csClass" })
vim.api.nvim_set_hl(0, "@lsp.type.enum.rust", { link = "csInterface" })
vim.api.nvim_set_hl(0, "@lsp.type.enumMember.rust", { link = "csEnumMemberName" })

-------------------------
-- plugin nvim-treesitter
-------------------------
local ts_enabled_for = {
  ["c"] = true,
  ["cpp"] = true,
  ["python"] = true,
  ["devicetree" ] = true,
  ["json5"] = true,
  ["json"] = true,
  ["yaml"] = true,
  ["xml"] = true,
  ["rst"] = true,
  ["cmake"] = true,
  ["lua"] = true,
}

require('nvim-treesitter.configs').setup {
  -- silence lua language server warnings
  ensure_installed = { },
  ignore_install = { },
  modules = {},

  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,

    disable = function(lang, _)
      return not ts_enabled_for[lang]
    end,

    additional_vim_regex_highlighting = false,
  },
  indent = {
    enable = true,
    disable = function(lang, _)
      return not ts_enabled_for[lang]
    end,
  }
}

require('copilot').setup({
  panel = {
    enabled = false,
  },
  suggestion = {
    enabled =false,
  },
  filetypes = {
    cpp = true,
    python = true,
    yaml = false,
    markdown = false,
    help = false,
    gitcommit = false,
    gitrebase = false,
    hgcommit = false,
    svn = false,
    ["."] = false
  },
  copilot_node_command = vim.fn.expand("$HOME") .. '/.nvm/versions/node/v18.20.1/bin/node',
  server_opts_overrides = {},
})

vim.api.nvim_set_hl(0, "@include", { link = "PreProc" })
vim.api.nvim_set_hl(0, "@repeat", { link = "cConditional" })
vim.api.nvim_set_hl(0, "@conditional", { link = "cConditional" })
vim.api.nvim_set_hl(0, "@punctuation.delimiter", { link = "Normal" })
vim.api.nvim_set_hl(0, "@punctuation.bracket", { link = "Normal" })
vim.api.nvim_set_hl(0, "@keyword.operator.c", { link = "Type" })

vim.api.nvim_set_hl(0, "@constant.builtin", { link = "Type" })
vim.api.nvim_set_hl(0, "@type.builtin", { link = "csClass" })

vim.api.nvim_set_hl(0, "@exception", { link = "Type" })
vim.api.nvim_set_hl(0, "@keyword", { link = "Type" })
vim.api.nvim_set_hl(0, "@type.python", { link = "csClass" })
vim.api.nvim_set_hl(0, "@variable.builtin.python", { link = "Type" })
vim.api.nvim_set_hl(0, "@constructor.python", { link = "csClass" })
vim.api.nvim_set_hl(0, "@constructor.python", { link = "csClass" })

vim.api.nvim_set_hl(0, "@type.builtin.cpp", { link = "Type" })
vim.api.nvim_set_hl(0, "@type.cpp", { link = "csClass" })
vim.api.nvim_set_hl(0, "@variable.builtin.cpp", { link = "Type" })

vim.api.nvim_set_hl(0, "@constant.devicetree", { link = "PreProc" })
vim.api.nvim_set_hl(0, "@namespace.devicetree", { link = "rustAttribute" })
vim.api.nvim_set_hl(0, "@property.devicetree", { link = "vimHiKeyList" })
vim.api.nvim_set_hl(0, "@label.devicetree", { link = "PreProc" })

vim.api.nvim_set_hl(0, "@keyword.json5", { link = "yamlField" })
vim.api.nvim_set_hl(0, "@string.json5", { link = "yamlString" })
vim.api.nvim_set_hl(0, "@number.json5", { link = "yamlInteger" })
vim.api.nvim_set_hl(0, "@boolean.json5", { link = "yamlBool" })

vim.api.nvim_set_hl(0, "@label.json", { link = "yamlField" })
vim.api.nvim_set_hl(0, "@string.json", { link = "yamlString" })
vim.api.nvim_set_hl(0, "@number.json", { link = "yamlInteger" })
vim.api.nvim_set_hl(0, "@boolean.json", { link = "yamlBool" })

vim.api.nvim_set_hl(0, "@field.yaml", { link = "yamlField" })
vim.api.nvim_set_hl(0, "@string.yaml", { link = "yamlString" })
vim.api.nvim_set_hl(0, "@number.yaml", { link = "yamlInteger" })
vim.api.nvim_set_hl(0, "@comment.yaml", { link = "yamlComment" })
vim.api.nvim_set_hl(0, "@boolean.yaml", { link = "yamlBool" })

vim.api.nvim_set_hl(0, "@tag.xml", { link = "yamlField" })
vim.api.nvim_set_hl(0, "@string.xml", { link = "yamlString" })
vim.api.nvim_set_hl(0, "@constant.xml", { link = "rustAttribute" })
vim.api.nvim_set_hl(0, "@tag.attribute.xml", { link = "yamlInteger" })
vim.api.nvim_set_hl(0, "@tag.delimiter.xml", { link = "yamlField" })

vim.api.nvim_set_hl(0, "@punctuation.special.rst", { link = "rustAttribute" })
vim.api.nvim_set_hl(0, "@text.literal.rst", { link = "markdownCodeBlock" })
vim.api.nvim_set_hl(0, "@text.title.rst", { link = "Comment" })

vim.api.nvim_set_hl(0, "@variable.cmake", { link = "rustAttribute" })

vim.api.nvim_set_hl(0, "@type.c", { link = "csClass" })
vim.api.nvim_set_hl(0, "@type.builtin.c", { link = "Type" })
vim.api.nvim_set_hl(0, "@label.c", { link = "cConditional" })
vim.api.nvim_set_hl(0, "@constant.c", { link = "rustAttribute" })
vim.api.nvim_set_hl(0, "@character.c", { link = "String" })


vim.api.nvim_set_hl(0, "@punctuation.special.md", { link = "rustAttribute" })
vim.api.nvim_set_hl(0, "@text.literal.md", { link = "markdownCodeBlock" })
vim.api.nvim_set_hl(0, "@text.title.md", { link = "Comment" })

vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg ="#6CC644"})
