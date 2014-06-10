#xcfui

Xcode plugin for [fui tool](https://github.com/dblock/fui)

##Installation

###Dependencies
To use this plugin following gems are required:
*	[xcodeproj](https://rubygems.org/gems/xcodeproj)
*	[fui](http://rubygems.org/gems/fui)
Please install this dependencies first.

###Plugin
To install plugin download this, open Xcode project and run.
##Usage

##How it works

*	We first add 'Find unused imports' item in Xcode File menu. 
*	We swizzle Xcode build method
*	When 'Find unused imports' is checked and build method is called, we add new run script in build phases.
*	That run script executes fui tool on current project
*	It parse results and display them as warnings in Xcode
*	When 'Find unused imports' item is unchecked, we just remove run script from build phases. 