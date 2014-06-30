#xcfui

Xcode plugin for [fui tool](https://github.com/dblock/fui)

![Preview](https://raw.githubusercontent.com/jcavar/xcfui/master/preview.png)

##Install

###Dependencies
To use this plugin following gems are required:
*	[xcodeproj](https://rubygems.org/gems/xcodeproj)
*	[fui](http://rubygems.org/gems/fui)

Please install this dependencies first.

###Plugin

####Alcatraz
xcfui is available via [alcatraz](http://alcatraz.io/) 

####Manual
To install plugin download zip, open Xcode project and run. Restart Xcode.

##Uninstall
If you want to remove plugin delete xcfui.xcplugin from ~/Library/Application Support/Developer/Shared/Xcode/Plug-ins/ folder and restart Xcode.

##Usage

If you want to use xcfui just check 'Find unused imports' item under File menu, if you no longer want to use it just uncheck item

![Preview on](https://raw.githubusercontent.com/jcavar/xcfui/master/fui_preview_on.png)
![Preview off](https://raw.githubusercontent.com/jcavar/xcfui/master/fui_preview_off.png)

##How it works

*	We first add 'Find unused imports' item in Xcode File menu. 
*	We swizzle Xcode build method
*	When 'Find unused imports' is checked and build method is called, we add new run script in build phases.
*	That run script executes fui tool on current project
*	It parse results and display them as warnings in Xcode
*	When 'Find unused imports' item is unchecked, we just remove run script from build phases. 
