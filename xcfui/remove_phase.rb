require 'xcodeproj'
project = Xcodeproj::Project.open(ARGV[0])
main_target = project.targets.first
phases = main_target.shell_script_build_phases
phases.each { |phase|
    if (phase.name == "Find unused imports")
        phase.remove_from_project
        project.save()
    end
}
