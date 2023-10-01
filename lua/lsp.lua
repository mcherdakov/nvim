local on_attach = function(_, bufnr)
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = bufnr })
  vim.keymap.set("n", "<Leader>gt", vim.lsp.buf.type_definition, { buffer = bufnr })
  vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<cr>", { buffer = bufnr })

  -- diagnostics: next/previous errors in file
  vim.keymap.set("n", "<Leader>dn", vim.diagnostic.goto_next, { buffer = bufnr })
  vim.keymap.set("n", "<Leader>dp", vim.diagnostic.goto_prev, { buffer = bufnr })

  vim.keymap.set("n", "<Leader>rf", vim.lsp.buf.rename, { buffer = bufnr })
  vim.keymap.set("n", "<Leader>rr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
  vim.keymap.set("n", "<Leader>dd", "<cmd>Telescope diagnostics " .. "root_dir=" .. vim.fn.getcwd() .. "<cr>",
    { buffer = bufnr })

  -- Create a command `:Format` local to the LSP buffer
  -- vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
  --   vim.lsp.buf.format()
  -- end, { desc = 'Format current buffer with LSP' })

  vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = { "*" },
    callback = function()
      vim.lsp.buf.format()
    end,
  })
end

vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>")

local servers = {
  gopls = {
    -- gopls = {
    --   ['ui.completion.usePlaceholders'] = true,
    -- }
  },
  pyright = {},

  lua_ls = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      capabilities = capabilities,
      on_attach = on_attach,
      settings = servers[server_name],
      filetypes = (servers[server_name] or {}).filetypes,
    }
  end
}

-- [[ Configure nvim-cmp ]]
-- See `:help cmp`
local cmp = require 'cmp'
local luasnip = require 'luasnip'
require('luasnip.loaders.from_vscode').lazy_load()
luasnip.config.setup {}

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert {
    ['<C-n>'] = cmp.mapping.select_next_item(),
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete {},
    ['<CR>'] = cmp.mapping.confirm {
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    },
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_locally_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.locally_jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'buffer' },
    { name = 'nvim_lsp_signature_help' },
  },
  formatting = {
    format = function(entry, vim_item)
      vim_item.menu = ({
        nvim_lua = "[Lua]",
        nvim_lsp = "[LSP]",
        luasnip = "[LuaSnip]",
        buffer = "[Buffer]",
      })[entry.source.name]
      return vim_item
    end
  },
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
  pattern = { "*.go" },
  callback = function()
    vim.bo.tabstop = 4
    vim.bo.shiftwidth = 0 -- same as tabstop
    vim.bo.expandtab = true
  end,
})
