local overrides = require "configs.overrides"

return {
  {
    "nvchad/ui",
    config = function()
      require "nvchad"
    end,
  },
  {
    "nvchad/base46",
    branch = "v3.0",
    lazy = true,
    build = function()
      require("base46").load_all_highlights()
    end,
  },
  {
    "folke/which-key.nvim",
    lazy = false,
    opts = function()
      dofile(vim.g.base46_cache .. "whichkey")
      return {}
    end,
  },
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    opts = require "configs.conform",
  },
  {
    "neovim/nvim-lspconfig",
    event = "User FilePost",
    config = function()
      require "configs.lspconfig"
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = {
        "html",
        "cssls",
        "gopls",
        "vue_ls",
        "vtsls",
        "angularls",
        "zls",
        "bashls",
        "clangd",
        "lua_ls",
      },
      automatic_enable = false,
    },
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    event = "VeryLazy",
    dependencies = {
      "mason-org/mason.nvim",
      "mfussenegger/nvim-dap",
    },
    opts = {
      ensure_installed = {
        "codelldb",
        "delve",
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    lazy = false,
    opts = function()
      return require "configs.treesitter"
    end,
    config = function(_, opts)
      require("nvim-treesitter").setup()
      require("nvim-treesitter").install(opts.ensure_installed)
    end,
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = { "qf" },
    config = function()
      require "configs.bqf"
    end,
  },
  {
    "mrcjkb/rustaceanvim",
    branch = "main",
    version = "^8",
    lazy = false,
    init = function()
      vim.g.rustaceanvim = {
        server = {
          default_settings = {
            ["rust-analyzer"] = {
              check = { command = "clippy" },
            },
          },
        },
      }
    end,
  },
  {
    "rust-lang/rust.vim",
    branch = "main",
    ft = "rust",
  },
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
    end,
  },
  {
    "leoluz/nvim-dap-go",
    ft = "go",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap" },
    opts = {},
  },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saecki/crates.nvim",
    ft = { "rust", "toml" },
    opts = {
      autoload = true,
      lsp = {
        enabled = true,
        actions = true,
        completion = true,
        hover = true,
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    event = "VeryLazy",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "qnighy/lalrpop.vim",
    ft = { "lalrpop" },
  },
  { "tpope/vim-fugitive" },
  {
    "rbong/vim-flog",
    dependencies = {
      "tpope/vim-fugitive",
    },
    lazy = false,
  },
  {
    "vuki656/package-info.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    lazy = false,
    opts = {
      autostart = true,
    },
  },
  {
    "sindrets/diffview.nvim",
    lazy = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-neotest/neotest",
    event = "VeryLazy",
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace "neotest"
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup {
        adapters = {
          require "rustaceanvim.neotest",
          require "neotest-golang",
        },
      }
    end,
    dependencies = {
      "nvim-neotest/nvim-nio",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      { "fredrikaverpil/neotest-golang", version = "*" },
      "mrcjkb/rustaceanvim",
    },
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      return require "nvchad.configs.gitsigns"
    end,
    config = function(_, opts)
      require("gitsigns").setup(opts)
      vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", { desc = "Toggle blame" })
    end,
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = {
      "LazyGit",
      "LazyGitConfig",
      "LazyGitCurrentFile",
      "LazyGitFilter",
      "LazyGitFilterCurrentFile",
    },
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "nvim-lua/plenary.nvim",
    },
    config = function()
      require("telescope").load_extension "lazygit"
    end,
  },
  {
    "cordx56/rustowl",
    version = "*",
    -- shell builds inherit lazy's git.timeout (120s), too short to compile rustowl.
    -- Install from the plugin dir so rustup picks up its pinned nightly (rustc-dev).
    build = function(plugin)
      local Async = require("lazy.async")
      local done, result = false, nil
      vim.system({ "cargo", "install", "--locked", "--path", "." }, { cwd = plugin.dir }, function(r)
        result, done = r, true
      end)
      while not done do
        Async.sleep(500)
      end
      if result.code ~= 0 then
        error(result.stderr)
      end
    end,
    ft = { "rust" },
    opts = function()
      local installed = vim.fn.executable("rustowl") == 1
      if not installed then
        vim.notify_once(
          "rustowl: binary not found. Run `:Lazy build rustowl`.",
          vim.log.levels.WARN
        )
      end
      return {
        auto_attach = installed,
      }
    end,
  },
  {
    "aspeddro/gitui.nvim",
    config = function()
      require("gitui").setup()
    end,
  },
}
