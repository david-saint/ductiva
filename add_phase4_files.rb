require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

# Add HabitCalendarDayState.swift to ductivaWidgets target
state_file = project.files.find { |f| f.path == 'ductiva/HabitCalendarDayState.swift' }
if state_file.nil?
  state_file = project.new(Xcodeproj::Project::Object::PBXFileReference)
  state_file.path = 'ductiva/HabitCalendarDayState.swift'
  state_file.name = 'HabitCalendarDayState.swift'
  state_file.source_tree = '<group>'
  project.main_group.children << state_file
end
unless widgets_target.source_build_phase.files_references.include?(state_file)
  widgets_target.source_build_phase.add_file_reference(state_file)
end

project.save
puts "Added HabitCalendarDayState.swift to ductivaWidgets target."
