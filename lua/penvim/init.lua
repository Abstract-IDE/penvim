
local M={}


local default = {
	project_env = {
		enable = true,
		config_name = '.__nvim__.lua'
	},

	langs = {
		enable = false
	},

	rooter = {
		enable = true,
		patterns = {
			'.__nvim__.lua', '.git', 'node_modules', '.sln', '.svn', 'wwwroot', '.projectile',
			'rebar.config', -- Rebar project file
			'project.clj', --Leiningen project file
			'build.boot', --Boot-clj project file
			'deps.edn', --Clojure CLI project file
			'SConstruct', --Scons project file
			'default.nix', --Nix project file
			'flake.nix', --Nix flake project file
			'pom.xml', --Maven project file
			'build.sbt', --SBT project file
			'build.sc', --Mill project file
			'gradlew', --Gradle wrapper script
			'build.gradle', --Gradle project file
			'.ensime', --Ensime configuration file
			'Gemfile', --Bundler file
			'requirements.txt', --Pip file
			'setup.py', --Setuptools file
			'tox.ini', --Tox file
			'composer.json', --Composer project file
			'Cargo.toml', --Cargo project file
			'mix.exs', --Elixir mix project file
			'stack.yaml', --Haskell’s stack tool based project
			'dune-project', --OCaml Dune project file
			'info.rkt', --Racket package description file
			'DESCRIPTION', --R package description file
			--TAGS etags/ctags are usually in the root of project', --GTAGS GNU Global tags
			'configure.in', --autoconf old style
			'configure.ac', --autoconf new style
			'cscope.out', --cscope
			'go.mod', -- go project
		}
	},

	-- indentor
	indentor = {
		enable = true, -- enable/disable indentor
		indent_length = 4, -- tab indent width or no of spaces in case of indent_type
		indent_type = "auto", -- if file is new or it doesn't have any indentation (auto, tab, space)
		accuracy = 5, -- positive integer. higher the number, the more accurate result (but affects the startup time)
		disable_types = {
			'help','dashboard','dashpreview','NvimTree','vista','sagahover'
		},
	},
}


function M.setup(options)

	-- default options
	---------------------------------------
	-- project_env default config
	vim.g.penvim_project_enable = default.project_env.enable
	vim.g.penvim_project_config = default.project_env.config_name
	-- langs default config
	vim.g.penvim_langs_enable = default.langs.enable
	-- rooter default config
	vim.g.penvim_rooter_enable = default.rooter.enable
	vim.g.penvim_rooter_patterns = default.rooter.patterns
	-- indentor default config
	vim.g.penvim_indentor_enable = default.indentor.enable
	vim.g.penvim_indentor_length = default.indentor.indent_length
	vim.g.penvim_indentor_indent = default.indentor.indent_type
	vim.g.penvim_indentor_accuracy = default.indentor.accuracy
	local disable_types = default.indentor.disable_types

	--
	local filetype = vim.bo.filetype
	local buftype = vim.bo.buftype



	-- overide default options with user-defined options
	---------------------------------------
	if options ~= nil then
		-- project_env
		if options.project_env ~= nil then
			if options.project_env.enable ~= nil then
				vim.g.penvim_project_enable = options.project_env.enable
			end
			if options.project_env.config_name ~=nil then
				vim.g.penvim_project_config = options.project_env.config_name
			end
		end

		-- langs
		if options.langs ~= nil and options.langs.enable ~= nil then
			vim.g.penvim_langs_enable = options.langs.enable
		end

		-- rooter
		if options.rooter ~= nil then
			if options.rooter.enable ~= nil then
				vim.g.penvim_rooter_enable = options.rooter.enable
			end
			if options.rooter.patterns ~= nil then
				local default_pattern = default.rooter.patterns
				local option_pattern = options.rooter.patterns

				for _, value in pairs(option_pattern) do
					default_pattern[#default_pattern+1] = value
				end
				vim.g.penvim_rooter_patterns = default_pattern
			end
		end

		-- indentor
		if options.indentor ~= nil then
			if options.indentor.enable ~= nil then
				vim.g.penvim_indentor_enable = options.indentor.enable
			end
			if options.indentor.indent_length ~=nil then
				vim.g.penvim_indentor_length = options.indentor.indent_length
			end
			if options.indentor.indent_type ~=nil then
				vim.g.penvim_indentor_indent = options.indentor.indent_type
			end
			if options.indentor.accuracy ~=nil then
				vim.g.penvim_indentor_accuracy = options.indentor.accuracy
			end
			if options.indentor.disable_types ~=nil then
				local default_disable_types = default.indentor.disable_types
				local option_disable_types = options.indentor.disable_types
				for _, value in pairs(option_disable_types) do
					default_disable_types[#default_disable_types+1] = value
				end
				disable_types = default_disable_types
			end
		end
	end

	local group = vim.api.nvim_create_augroup("PenvimAutoGroup", {clear=true})

	-- TODO:
	-- language
	---------------------------------------
	if vim.g.penvim_langs_enable then
		vim.api.nvim_create_autocmd(
			"BufEnter",
			{
				pattern = "*",
				group = group,
				command = "lua require('penvim.langs').load_langs()"
			}
		)
	end

	-- project environment
	---------------------------------------
	if vim.g.penvim_project_enable then
		vim.api.nvim_create_autocmd(
			"BufEnter",
			{
				pattern = "*",
				group = group,
				command = "lua require('penvim.project_env').load_project_config()"
			}
		)
	end

	-- rooter
	---------------------------------------
	if vim.g.penvim_rooter_enable then
		vim.api.nvim_create_autocmd(
			"BufEnter",
			{
				pattern = "*",
				group = group,
				command = "lua require('penvim.rooter').load_rooter()"
			}
		)
	end

	-- TODO:
	-- indentor
	---------------------------------------
	if vim.g.penvim_indentor_enable then

		-- don't load indentor if filetype is passed in options
		for _, ft in pairs(disable_types) do
			if ft==filetype or ft==buftype then
                                return
                        end
		end

		vim.api.nvim_create_autocmd(
			"BufEnter",
			{
				pattern = "*",
				group = group,
				command = "lua require('penvim.indentor').load_indentor()"
			}
		)
	end

end


return M

