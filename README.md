<br/>
<p align="center">
  <h3 align="center">PenVim</h3>

  <p align="center">
    project's root directory and documents indentation detector with project based config loader
    <br/>
    <br/>
    <br/>
  </p>
</p>


<div align="center" >

  <a href="https://github.com/shaeinst/penvim/">Docs</a>
  <a href="https://github.com/shaeinst/penvim/issues">Request-Feature/Issues</a>
  </br>
  ![Contributors](https://img.shields.io/github/contributors/shaeinst/penvim?color=dark-green) ![Issues](https://img.shields.io/github/issues/shaeinst/penvim) ![License](https://img.shields.io/github/license/shaeinst/penvim) ![Forks](https://img.shields.io/github/forks/shaeinst/penvim?style=social) ![Stargazers](https://img.shields.io/github/stars/shaeinst/penvim?style=social)
</div>




## Table Of Contents

* [About the Project](#about-the-project)
* [Examples](#examples-)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Setup](#setup)
* [License](#license)
* [Acknowledgements](#acknowledgements)


## About The Project

This plugin (Penvim) has 4 purposes:
1. change current working directory to project's root directory.
2. detect indentation of Document (Source Code) and set indentation related config according to detected indentation
3. load config defined in project's root directory
4. set options according to Language's Standard Style Guide (not implemented yet...)


## Getting Started
Install PenVim using your favorite package manager.


### Prerequisites
* neovim >= 0.7


### Installation

using ```vim-plug```
```lua
Plug 'Abstract-IDE/penvim'
```
or using packer.nvim
```lua
use {'Abstract-IDE/penvim'}
```


## Setup

```lua
require("penvim").setup() -- use defaults
```
#### Full Configuration
```lua
require("penvim").setup({
	rooter = {
		enable = true, -- enable/disable rooter
		patterns = {'.__nvim__.lua', '.git', 'node_modules'}
	},
	indentor = {
		enable = true, -- enable/disable indentor
		indent_length = 4, -- tab indent width
		accuracy = 5, -- positive integer. higher the number, the more accurate result (but affects the startup time)
		disable_types = {
			'help','dashboard','dashpreview','NvimTree','vista','sagahover', 'terminal',
		},
	},
	project_env = {
		enable = true, -- enable/disable project_env
		config_name = '.__nvim__.lua' -- config file name
	},
})
```


## Examples :
<details>
	<summary>
		sample, config defined in project's root directory
	</summary>

```lua
-- .__nvim__.lua
return {
	-- for all file types
	all = {
		tabstop = 4, -- spaces per tab
		cursorline = true, -- highlight current line
		relativenumber = true, -- show relative line number
		number = true, -- show line numbers
	},

	-- for filetype lua
	lua = {	
		smarttab = true, -- <tab>/<BS> indent/dedent in leading whitespace
		softtabstop = 4,
		shiftwidth = 4, -- spaces per tab (when shifting), when using the >> or << commands, shift lines by 4 spaces
	},
	
	-- for filetype python and javascript
	py_js = {
		tabstop = 4, -- spaces per tab
		wrap = false, -- don't automatically wrap on load
	}
}
```
</details>


## To-Do
* testing
* implement to set option according to Language's Standard Style Guide
* optimize code


## License
Distributed under the MIT License. See [LICENSE](https://github.com/shaeinst/penvim/blob/main/LICENSE) for more information.


## Acknowledgements
* for [README](https://readme.shaankhan.dev/)

