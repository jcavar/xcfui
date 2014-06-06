require 'xcodeproj'
project = Xcodeproj::Project.open(ARGV[0])
main_target = project.targets.first

#check if find script already exists and if exists do nothing
phases = main_target.shell_script_build_phases
phases.each { |phase|
    if (phase.name == "Find unused imports")
        exit
    end
}

#otherwise add new target
phase = main_target.new_shell_script_build_phase("Find unused imports")
phase.shell_script = "/bin/sh \"#{ARGV[1]}\" \"#{ARGV[2]}\""
project.save()