require 'xcodeproj'
project = Xcodeproj::Project.open(ARGV[0])
main_target = project.targets.first
phase = main_target.new_shell_script_build_phase("Find unused imports")
phase.shell_script = "fui --path=#{ARGV[1]} find | while read -r line ; do echo $line 1:1: warning: Unused import done"
project.save()