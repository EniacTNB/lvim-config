-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny
lvim.plugins = {
        {
                -- {
                -- -@type Flash.Config
                -- },
                -- ctags 被 neovim 内建支持, 当tags文件存在时可以
                -- <C-]> 跳转到符号定义的地方
                -- <C-o> 返回跳转前的代码

                -- ctags 只能建立了符号定义的索引,没有建立被调用的索引,因此用cscope来加速被引用的搜索
                -- <leader>cc	搜索光标函数被调用的地方
                -- <leader>ca	搜索光标符号被赋值的地方
                -- <leader>cs	搜索光标符号出现的所有地方
                -- <leader>cg	搜索光标符号的定义,等于ctags的<C+]>
                -- <leader>cG	产生cscope.files文件
                -- <leader>ct	搜索光标类型的实例
                -- <leader>cT	生成索引文件cscope.out
                -- <leader>ce	用egrep方式搜索光标符号, == grep -E 就是 把+ ? | 等当作逻辑符号,而不是一般异常符号来处理, ls | egrep "mp4|avi"
                -- <leader>cf	打开光标文件
                -- <leader>ci	搜索include了光标文件名的所有文件
                -- <leader>cd	搜索被光标函数调用的函数
                "kmontocam/nvim-conda",
                {
                        "keaising/im-select.nvim",
                        config = function()
                                require("im_select").setup({})
                        end,
                },
                -- 增加Auto_Session插件，可以在下次打开lvim的时候自动恢复上次关闭的状态
                {
                        -- 还原窗口布局和打开的文件(利用的是nvim本身的会话功能)
                        --  ":mksession SessionName" -- ":source SessionName"   #创建文件SessionName保存当前的窗口layout状态, source则利用这些信息恢复窗口状态
                        --      ":wviminfo VimInfo" -- ":rviminfo VimInfo"              #创建文件VimInfo保存操作的历史记录,命令的历史记录等, 恢复那些记录
                        -- 只是存储的会话信息,不在代码目录里,默认统一放到 ~/.local/share/lvim/sessions 下了
                        -- 带参数启动lvim虽然不会自动还原, 但可以 :RestoreSession 手动还原, 与之对应 :SaveSession 手动保存
                        "rmagatti/auto-session",
                        config = function()
                                require('lualine').setup {
                                        options = { theme = 'tokyonight', },
                                        sections = { lualine_c = { require('auto-session').current_session_name } }
                                }
                                require("auto-session").setup({
                                        log_level = "info",
                                        auto_session_enable_last_session = false,
                                        auto_session_root_dir = nil,
                                        auto_session_enabled = true,
                                        auto_save_enabled = true,
                                        auto_restore_enabled = true,
                                        -- auto_session_suppress_dirs = { "~/", "~/Projects" },
                                        auto_session_suppress_dirs = nil,
                                        auto_session_use_git_branch = false,
                                })
                        end,
                },
                {
                        -- 记住退出lvim时光标在文件的行号,重新打开此文件时自动跳转到上次光标行
                        "ethanholz/nvim-lastplace",
                        -- event = "BufRead",
                        config = function()
                                require("nvim-lastplace").setup({
                                        lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
                                        lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
                                        lastplace_open_folds = true,
                                })
                        end,
                },

                {
                        -- 多关键字高亮
                        -- let HiSet   = 'f<CR>'
                        -- let HiErase = 'f<BS>'
                        -- let HiClear = 'f<C-L>'
                        -- let HiFind  = 'f<Tab>'
                        "azabiong/vim-highlighter",
                },

                {
                        -- 让代码滚动更顺滑, 当前要么jk一行一行的滚动, 要么<C-u/d> 直接半屏的跳(没有中间过程), 此插件可以显示半屏或整屏滚动的中间过程, 且中间过程丝滑快捷
                        "karb94/neoscroll.nvim",
                        event = "WinScrolled",
                        config = function()
                                require('neoscroll').setup({
                                        -- All these keys will be mapped to their corresponding default scrolling animation
                                        mappings = { '<C-u>', '<C-d>', -- 半屏上下滚(光标行在屏上的位置不动)
                                                '<C-b>', '<C-f>', -- 整屏上下滚(光标行在屏上的位置不动)
                                                '<C-y>', '<C-e>', -- 逐行上下滚(光标行在屏上的位置跟着动)
                                                'zt', 'zz', 'zb' }, -- 光标行和代码行一起居3/4,居中,1/4
                                        hide_cursor = true, -- Hide cursor while scrolling
                                        stop_eof = true, -- Stop at <EOF> when scrolling downwards
                                        use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
                                        respect_scrolloff = false, -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                                        cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                                        easing_function = nil, -- Default easing function
                                        pre_hook = nil, -- Function to run before the scrolling animation starts
                                        post_hook = nil, -- Function to run after the scrolling animation ends
                                })
                        end
                        -- 涉及三个物体的关系,
                        -- 一个相对人眼固定不动的窗口--屏幕;
                        -- 一条存储了N行代码的长纸带,纸带能相对窗口上下移动;
                        -- 一个光标所在行,能在屏幕内上下移动;

                        -- <C-u>	光标行与屏幕相对静止,纸带下滚半屏
                        -- <C-d>	光标行与屏幕相对静止,纸带上滚半屏
                        -- <C-b>	光标行与屏幕相对静止,纸带下滚全屏
                        -- <C-f>	光标行与屏幕相对静止,纸带上滚全屏

                        -- <C-y>	光标行与纸带相对静止,纸带逐行下滚
                        -- <C-e>	光标行与纸带相对静止,纸带逐行上滚
                        -- zt	        光标行与纸带相对静止,纸带上滚到区间顶
                        -- zz	        光标行与纸带相对静止,纸带滚到区间中
                        -- zb	        光标行与纸带相对静止,纸带下滚到区间底
                },
                {
                        -- 当代码块太长时, 本插件把函数名/switch 行等pin住, 滚动代码时知道光标在哪个代码块里
                        -- 有点类似于代码阅读时的目录树, 但是是实时的, 且只显示当前光标所在的代码块 例如在xxx文件中的xxx函数中 这样的语法树结构
                        "romgrk/nvim-treesitter-context",
                        config = function()
                                require("treesitter-context").setup {
                                        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
                                        throttle = true, -- Throttles plugin updates (may improve performance)
                                        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
                                        patterns = {
                                                -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
                                                -- For all filetypes
                                                -- Note that setting an entry here replaces all other patterns for this entry.
                                                -- By setting the 'default' entry below, you can control which nodes you want to
                                                -- appear in the context window.
                                                default = {
                                                        'class',
                                                        'function',
                                                        'method',
                                                },
                                        },
                                }
                        end
                        -- :TSContextToggle
                        -- :TSContextEnable
                        -- :TSContextDisable
                },
                {
                        -- vim最广泛使用的git插件
                        "tpope/vim-fugitive",
                        cmd = {
                                "G",
                                "Git",
                                "Gdiffsplit",
                                "Gread",
                                "Gwrite",
                                "Ggrep",
                                "GMove",
                                "GDelete",
                                "GBrowse",
                                "GRemove",
                                "GRename",
                                "Glgrep",
                                "Gedit"
                                -- :Git <Tab>					能提示所有Git 命令
                                -- :Git add
                                -- :Git commit
                                -- :Git rebase -i
                                -- :Git diff
                                -- :Git log
                                -- :Git blame					新开窗口显示本源文件每行的最后提交
                                -- :Git mergetool					合并 diffview 的命令
                                -- :Gdiffsplit					以左右分屏方式对比当前文件未提交的修改
                                -- :Ggrep 						Ggrep==git grep, 搜索git 关注的文件类型, ignore的不看
                                -- :Ggrep ValidMode HEAD~1				在当前branch的某个历史版本里去搜索
                                -- :Ggrep ValidMode specificBranch			在某个branch的最新状态上去搜索
                                -- :Ggrep ValidMode HEAD HEAD~100 specificBranch	在某个branch的一段历史上去搜索
                                -- :Ggrep ValidMode HEAD HEAD~100 			在当前branch的一段历史上去搜索
                                -- :GMove						==git mv,
                                -- :GRename					==git rename
                                -- :GDelete					==git rm
                                -- $ git log --patch -G"release_vcpi_slots" .	命令行里搜索某个文件/目录的修改记录里包含关键字的commit␓
                        },
                        ft = { "fugitive" }
                },
                {
                        -- 显示当前源文件的符号和函数列表
                        -- 下面定义F5为toggle "symbols outline" 窗口的快捷键
                        -- lvim.keys.normal_mode["<F5>"] = ":SymbolsOutline<CR>"

                        -- Esc		Close outline
                        -- Enter	Go to symbol location in code
                        -- o		Go to symbol location in code without losing focus
                        -- Ctrl+Space	Hover current symbol
                        -- K		Toggles the current symbol preview
                        -- r		Rename symbol
                        -- a		Code actions
                        -- h		fold symbol
                        -- l		Unfold symbol
                        -- W		Fold all symbols
                        -- E		Unfold all symbols
                        -- R		Reset all folding
                        -- ?		Show help message

                        "simrat39/symbols-outline.nvim",
                        config = function()
                                require("symbols-outline").setup({
                                        highlight_hovered_item = true,
                                        show_guides = true,
                                        auto_preview = false,
                                        position = 'right',
                                        relative_width = true,
                                        width = 25,
                                        auto_close = false,
                                        show_numbers = false,
                                        show_relative_numbers = false,
                                        show_symbol_details = true,
                                        preview_bg_highlight = 'Pmenu',
                                        autofold_depth = nil,
                                        auto_unfold_hover = true,
                                        fold_markers = { '', '' },
                                        wrap = false,
                                        keymaps = {
                                                -- These keymaps can be a string or a table for multiple keys
                                                close = { "<Esc>", "q" },
                                                goto_location = "<Cr>",
                                                focus_location = "o",
                                                hover_symbol = "<C-space>",
                                                toggle_preview = "K",
                                                rename_symbol = "r",
                                                code_actions = "a",
                                                fold = "h",
                                                unfold = "l",
                                                fold_all = "W",
                                                unfold_all = "E",
                                                fold_reset = "R",
                                        },
                                        lsp_blacklist = {},
                                        symbol_blacklist = {},
                                        symbols = {
                                                File = { icon = "", hl = "@text.uri" },
                                                Module = { icon = "", hl = "@namespace" },
                                                Namespace = { icon = "", hl = "@namespace" },
                                                Package = { icon = "", hl = "@namespace" },
                                                Class = { icon = "𝓒", hl = "@type" },
                                                Method = { icon = "ƒ", hl = "@method" },
                                                Property = { icon = "", hl = "@method" },
                                                Field = { icon = "", hl = "@field" },
                                                Constructor = { icon = "", hl = "@constructor" },
                                                Enum = { icon = "ℰ", hl = "@type" },
                                                Interface = { icon = "ﰮ", hl = "@type" },
                                                Function = { icon = "", hl = "@function" },
                                                Variable = { icon = "", hl = "@constant" },
                                                Constant = { icon = "", hl = "@constant" },
                                                String = { icon = "𝓐", hl = "@string" },
                                                Number = { icon = "#", hl = "@number" },
                                                Boolean = { icon = "⊨", hl = "@boolean" },
                                                Array = { icon = "", hl = "@constant" },
                                                Object = { icon = "⦿", hl = "@type" },
                                                Key = { icon = "🔐", hl = "@type" },
                                                Null = { icon = "NULL", hl = "@type" },
                                                EnumMember = { icon = "", hl = "@field" },
                                                Struct = { icon = "𝓢", hl = "@type" },
                                                Event = { icon = "🗲", hl = "@type" },
                                                Operator = { icon = "+", hl = "@operator" },
                                                TypeParameter = { icon = "𝙏", hl = "@parameter" },
                                                Component = { icon = "", hl = "@function" },
                                                Fragment = { icon = "", hl = "@constant" },
                                        },
                                })
                        end,
                },
                {
                        -- diffview.nvim 以vim diff的左右窗口对比的方式呈现每笔修改
                        "sindrets/diffview.nvim",
                        event = "BufRead",
                        -- bufferline/buffer/代码窗口(vs 或者 split产生的众多代码窗口) 之间的关系:
                        -- bufferline是一个状态条,里面有所有打开的buffer(i.e. 一个源代码文件名), 而一个代码窗口只代表一个矩形区域, 一个buffer可以出现在一个或者多个window里, 而一个window也可以对应多个buffer.
                        -- <leader>c关闭的是buffer, 如果此buffer被多个窗口打开, 那么所有窗口都将关闭此文件, 窗口切换为显示bufferline里的候补文件, 如果bufferline空了, 所有窗口将关闭, 并创建一个未命名buffer窗口
                        -- <leader>q关闭的是window, 此窗口将消失, 代码窗口区域还原成创建此窗口前的样子, 如果此window关联着多个buffer, buffer可能并没有被关闭, bufferline还存在, 点击 bufferline 还能打开代码窗口

                        -- lvim原有的nvimtree 和 代码窗口 共同组成了一个layer, 我把Diffview的窗口也定义为一层layer, 它比原layer在z-order上高一层, 会挡住原有layer
                        -- :[range]DiffviewFileHistory [paths] [options]	Opens a new file history view that lists all commits that affected the given paths.
                        -- :DiffviewFileHistory                                 倒品窗口查看当前branch的历史commit(底部窗口，同时缩进展示本commit修改了哪些文件)，选中文件后回车将在上部左右窗口vimdiff形式直观展示修
                        -- :DiffviewFileHistory %                               倒品窗口查看当前文件的历史commit，同样以diff方式展示
                        -- :h DiffviewFileHistory                               help
                        -- :DiffviewFileHistory path/to/some/file.txt
                        -- :DiffviewFileHistory path/to/some/directory
                        -- :DiffviewFileHistory include/this and/this :!but/not/this
                        -- :DiffviewFileHistory --range=origin..HEAD
                        -- :DiffviewFileHistory --range=feat/example-branch
                        -- :'<,'>DiffviewFileHistory
                        -- Familiarize Yourself With :h diff-mode


                        -- :DiffviewOpen [git rev] [options] [ -- {paths...}]   比较版本间的差异，可以指定具体不同commit和文件, 左中右三窗口，左是版本间差异涉及哪些文件，中右是vimdiff.
                        -- 							左边文件列表窗口里,可以通过<tab> and <s-tab>遍历文件列表
                        -- Examples:
                        -- :DiffviewOpen					和 lvim原生git插件的 <leader>gd 效果一致, 和 "tpope/vim-fugitive"的 :Gdiffsplit 效果一致
                        -- :DiffviewOpen HEAD~2
                        -- :DiffviewOpen HEAD~4..HEAD~2
                        -- :DiffviewOpen d4a7b0d
                        -- :DiffviewOpen d4a7b0d^!
                        -- :DiffviewOpen d4a7b0d..519b30e
                        -- :DiffviewOpen origin/main...HEAD
                        -- :DiffviewOpen HEAD~2 -- lua/diffview plugin
                        -- :DiffviewClose                                       == :tabclose. 关闭diffview层
                        -- :DiffviewToggleFiles                                 Toggle 左边文件列表窗口
                        -- :DiffviewFocusFiles                                  光标移动到左边文件列表窗口
                        -- :DiffviewRefresh                                     刷新 Diffview

                },
                -- {
                --         "zbirenbaum/copilot.lua",
                --         cmd = "Copilot",
                --         event = "InsertEnter",
                --         config = function()
                --                 require("copilot").setup({})
                --         end,
                -- },
                -- {
                --         "zbirenbaum/copilot-cmp",
                --         after = { "copilot.lua" },
                --         config = function()
                --                 require("copilot_cmp").setup()
                --         end,
                -- },
                {
                        "HiPhish/nvim-ts-rainbow2",
                        -- Bracket pair rainbow colorize
                        lazy = true,
                        event = { "User FileOpened" },
                },
                {
                        "folke/flash.nvim",
                        event = "VeryLazy",
                        opts = {},
                        -- stylua: ignore
                        keys = {
                                { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
                                { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
                                { "r", mode = "o", function() require("flash").remote() end, desc = "Remote Flash" },
                                { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Treesitter Search" },
                                { "<c-s>", mode = { "c" }, function() require("flash").toggle() end, desc = "Toggle Flash Search" },
                        },
                },
                -- require('nvim-treesitter.configs').setup {
                --         rainbow = {
                --                 enable = true,
                --                 -- list of languages you want to disable the plugin for
                --                 disable = { 'jsx', 'cpp' },
                --                 -- Which query to use for finding delimiters
                --                 query = 'rainbow-parens',
                --                 -- Highlight the entire buffer all at once
                --                 strategy = require('ts-rainbow').strategy.global,
                --         }
                -- },
                {
                        "kevinhwang91/rnvimr",
                        cmd = "RnvimrToggle",
                        config = function()
                                vim.g.rnvimr_draw_border = 1
                                vim.g.rnvimr_pick_enable = 1
                                vim.g.rnvimr_bw_enable = 1
                        end,
                },
                {
                        'ojroques/nvim-lspfuzzy',
                        dependencies = {
                                'junegunn/fzf',
                                'junegunn/fzf.vim'
                        }
                },
                {

                        "dhananjaylatkar/cscope_maps.nvim",
                        dependencies = {
                                "folke/which-key.nvim",
                        },
                        config = function()
                                require("cscope_maps").setup({
                                        disable_maps = false, -- true disables my keymaps, only :Cscope will be loaded
                                })
                        end,

                },
                {

                        "nvim-lua/plenary.nvim",
                },
                {
                        "nvim-telescope/telescope-fzy-native.nvim",
                        build = "make",
                        event = "BufRead",
                },
                {
                        "nvim-telescope/telescope-project.nvim",
                        event = "BufWinEnter",
                        setup = function()
                                vim.cmd [[packadd telescope.nvim]]
                        end,
                },
                -- {
                --  -- Ranger file manager  但我感觉不好用，先注释掉
                --         "kevinhwang91/rnvimr",
                --         cmd = "RnvimrToggle",
                --         config = function()
                --                 vim.g.rnvimr_draw_border = 1
                --                 vim.g.rnvimr_pick_enable = 1
                --                 vim.g.rnvimr_bw_enable = 1
                --         end,
                -- },
                --
                -- {
                --         "camspiers/snap",
                --         rocks = "fzy",
                --         config = function()
                --                 local snap = require "snap"
                --                 local layout = snap.get("layout").bottom
                --                 local file = snap.config.file:with { consumer = "fzy", layout = layout }
                --                 local vimgrep = snap.config.vimgrep:with { layout = layout }
                --                 snap.register.command("find_files", file { producer = "ripgrep.file" })
                --                 snap.register.command("buffers", file { producer = "vim.buffer" })
                --                 snap.register.command("oldfiles", file { producer = "vim.oldfile" })
                --                 snap.register.command("live_grep", vimgrep {})
                --         end,
                -- },
                {
                        "rmagatti/goto-preview",
                        config = function()
                                require('goto-preview').setup {
                                        width = 120; -- Width of the floating window
                                        height = 25; -- Height of the floating window
                                        default_mappings = true; -- Bind default mappings
                                        debug = false; -- Print debug information
                                        opacity = nil; -- 0-100 opacity level of the floating window where 100 is fully transparent.
                                        post_open_hook = nil -- A function taking two arguments, a buffer and a window to be ran as a hook.
                                        -- You can use "default_mappings = true" setup option
                                        -- Or explicitly set keybindings
                                        -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
                                        -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
                                        -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
                                }
                        end
                },
                -- {
                --         "ahmedkhalf/project.nvim",
                --         opts = {
                --                 manual_mode = true,
                --         },
                --         event = "VeryLazy",
                --         config = function(_, opts)
                --                 require("project_nvim").setup(opts)
                --                                         end,
                --         keys = {
                --                  { "<leader>fp", "<Cmd>Telescope projects<CR>", desc = "Projects" },
                --         },
                -- },
                {
                        "ray-x/lsp_signature.nvim",
                        event = "BufRead",
                        config = function() require"lsp_signature".on_attach() end,
                },
                {
                        "folke/trouble.nvim",
                        cmd = "TroubleToggle",
                },
                {"ellisonleao/glow.nvim", config = true, cmd = "Glow"},
                {
                        "folke/todo-comments.nvim",
                        dependencies = { "nvim-lua/plenary.nvim" },
                        opts = {
                                -- your configuration comes here
                                -- or leave it empty to use the default settings
                                -- refer to the configuration section below
                        }
                },
                { 'wakatime/vim-wakatime', lazy = false },
                {
                        "felipec/vim-sanegx",
                        event = "BufRead",
                },
                {
                        "tpope/vim-surround",

                        -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
                        -- setup = function()
                        --  vim.o.timeoutlen = 500
                        -- end
                },
        },
}
-- lvim.on_load("telescope.nvim", function()
--                                         require("telescope").load_extension("projects")
--                                 end)


lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

lvim.builtin.telescope.on_config_done = function(telescope)
  pcall(telescope.load_extension, "frecency")
  pcall(telescope.load_extension, "neoclip")
  pcall(telescope.load_extension, "projects")
  -- any other extensions loading
end
lvim.builtin.treesitter.rainbow.enable = true

lvim.builtin.treesitter.rainbow.extended_mode = true
lvim.builtin.treesitter.rainbow.max_file_lines = 10000
lvim.keys.normal_mode["<F5>"] = ":SymbolsOutline<CR>"

table.insert(lvim.plugins, {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        dependencies = { "zbirenbaum/copilot.lua" },
        config = function()
                vim.defer_fn(function()
                        require("copilot").setup() -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
                        require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
                end, 100)
        end,
})

--lvim --headless +'lua require("lvim.utils").generate_settings()' +qa && sort -o lv-settings.lua{,}  -- 在当前目前生成lvim的所有配置 lv-settings.lua

lvim.keys.normal_mode["<C-s>"] = ":w<cr>"       -- Ctrl-s 保存文件
lvim.keys.normal_mode["<S-q>"] = ":wqa<CR>"     -- 保存修改并退出 lvim

-- lvim.keys.normal_mode["hd"] = "/<C-r><C-w><CR>" -- 交换两个窗口的位置
-- vim.opt.relativenumber = true                -- true则使用相对行号来标记代码行

-- 配置Tab缩进为8个空格的宽度
vim.opt.shiftwidth = 8                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 8                             -- insert 8 spaces for a tab
vim.opt.numberwidth = 8                         -- set number column width to 8 {default 4}

vim.opt.fileencoding = "utf-8"                  -- 写文件时使用utf-8代码页
vim.opt.ignorecase = true                       -- 搜索时忽略大小写
vim.opt.mouse = "a"                             -- 允许lvim使用鼠标操作
vim.opt.clipboard = "unnamedplus"               -- 使用OS 系统剪贴板

-- lvim.keys.normal_mode["<C-d>"] = "<C-d>zz"      -- Ctrl-d 将光标下翻半页并将光标行在窗口上下居中

-- cscope_maps 插件优先加载当前目录里的cscope.out, 然后加载与.git同级目录里的cscope.out,当只关注kernel的某个子模块目录时, 可以加速搜索
-- <leader>cT 是先检查当前文件是否属于git仓库管理的代码,是则在.git同级目录里创建cscope.out, 不是则在当前目录里创建
-- <S-t> 在当前目录里创建cscope.out, 且包含所有子目录和所有文件类型
lvim.keys.normal_mode["<S-t>"] = ":!cscope -bR && ctags -R<CR>"
lvim.keys.normal_mode["fs"] = ":Cscope find  s "        -- 手动输入要搜索的关键字, 查找此关键字所有出现的地方
lvim.keys.normal_mode["ts"] = ":Cscope find  g "        -- 手动输入要搜索的关键字, 查找此关键字定义的地方

-- treesitter自动下载
lvim.builtin.treesitter.auto_install = true
-- LSP自动下载
lvim.lsp.installer.setup.automatic_installation = true
-- vim.api.nvim_buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
--     vim.api.nvim_buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
-- ff 搜索光标关键字， gd被luarvim设置成LSP的goto definition，等同于vim的gd

-- local ok, copilot = pcall(require, "copilot")
-- if not ok then
--         return
-- end

-- copilot.setup {
--         suggestion = {
--                 keymap = {
--                         accept = "<c-l>",
--                         next = "<c-j>",
--                         prev = "<c-k>",
--                         dismiss = "<c-h>",
--                 },
--         },
-- }

-- local opts = { noremap = true, silent = true }
-- vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)
