#xcfui

Xcode plugin for [fui tool](https://github.com/dblock/fui)

##Installation
##Usage
##How it works

Plugin adds 'Find unused imports' item in File menu. When this item is checked, plugin intercepts Xcode build method and adds run script in build phases.
That run script execute fui tool on current project and results are displayed as warnings in Xcode
If you uncheck 'Find unused imports' item, this run script is just removed from build phases. 