<br/>
<p align="center">
  <h3 align="center">PenVim</h3>

  <p align="center">
    Project's Root Directory and Documents Indentation detector with project based config loader
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
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Setup](#setup)
* [License](#license)
* [Acknowledgements](#acknowledgements)


## About The Project

This plugin (Penvim) has 4 purposes:
1. change current working directory to project's root directory.
2. load config defined in project's root directory
3. detect indentation of Source Code and set indentation related config according to detected indentation (Working on it...)
4. set option according to Language's Standard Style Guide (Working on it...)


## Example :
<details>
	<summary>
		load config defined in project's root directory
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


## Getting Started
Install PenVim using your favorite package manager.


### Prerequisites
* neovim 0.6+


### Installation

using ```vim-plug```
```lua
Plug 'shaeinst/penvim'
```
or using packer.nvim
```lua
use {'shaeinst/penvim'}
```


## Setup

```lua
require("penvim").setup() -- use defaults
```
#### Full Configuration
```lua
require("penvim").setup({
	project_env = {
		enable = true,
		config_name = '.__nvim__.lua'
	},
	rooter = {
		enable = true,
		patterns = {'.__nvim__.lua', '.git', 'node_modules', '.sln', '.svn'}
	},
})
```


## To-Do
* Implement indentor (indentaion detector)
* implement to set option according to Language's Standard Style Guide
* optimize code


## License
Distributed under the MIT License. See [LICENSE](https://github.com/shaeinst/penvim/blob/main/LICENSE) for more information.


## Acknowledgements
* for [README](https://readme.shaankhan.dev/)

