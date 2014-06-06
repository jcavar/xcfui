#xcfui

Xcode plugin for [fui tool](https://github.com/dblock/fui)

##Installation
##Usage
##How it works

*We first add 'Find unused imports' item in Xcode File menu. 
*We swizzle Xcode build method
*When 'Find unused imports' is checked and build method is called, we add new run script in build phases.
*That run script executes fui tool on current project
*It parse results and display them as warnings in Xcode
*When 'Find unused imports' item is unchecked, we just remove run script from build phases. 