
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
		}
	},

	-- working on it ...
	-- indentor = {
	-- 	enable = true,
	-- 	lenght = 4
	-- },
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

	-- -- indentor
	-- vim.g.penvim_indentor_enable = default.indentor.enable
	-- vim.g.penvim_indentor_length = default.indentor.lenght


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

				for _, value in ipairs(option_pattern) do
					default_pattern[#default_pattern+1] = value
				end
				vim.g.penvim_rooter_patterns = default_pattern

			end
		end

		-- working on it...
		-- -- indentor
		-- if options.indentor ~= nil then
		-- 	if options.indentor.enable ~= nil then
		-- 		vim.g.penvim_indentor_enable = options.indentor.enable
		-- 	end
		-- 	if options.indentor.lenght ~=nil then
		-- 		vim.g.penvim_indentor_length = options.indentor.length
		-- 	end
		-- end
	end


	-- language
	---------------------------------------
	if vim.g.penvim_langs_enable then
		vim.cmd([[
			au BufEnter *.*  lua require("penvim.langs").load_langs()
		]])
	end

	-- project environment
	---------------------------------------
	if vim.g.penvim_project_enable then
		vim.cmd([[
			au BufEnter *.*  lua require("penvim.project_env").load_project_config()
		]])
	end

	-- rooter
	---------------------------------------
	if vim.g.penvim_rooter_enable then
		require("penvim.rooter").load_rooter()
	end

	-- -- working on it....
	-- -- indentor
	-- ---------------------------------------
	-- if vim.g.penvim_indentor_enable then
	-- 	require("penvim.indentor").load_indentor()
	-- end
	--
end


return M

