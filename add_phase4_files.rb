require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

# Add MediumSummaryWidgetView.swift to ductivaWidgets target
view_file = project.files.find { |f| f.path == 'ductiva/MediumSummaryWidgetView.swift' }
if view_file.nil?
  view_file = project.new(Xcodeproj::Project::Object::PBXFileReference)
  view_file.path = 'ductiva/MediumSummaryWidgetView.swift'
  view_file.name = 'MediumSummaryWidgetView.swift'
  view_file.source_tree = '<group>'
  project.main_group.children << view_file
end
unless widgets_target.source_build_phase.files_references.include?(view_file)
  widgets_target.source_build_phase.add_file_reference(view_file)
end

# Add HabitStreakService.swift to ductivaWidgets target
streak_service = project.files.find { |f| f.path == 'ductiva/HabitStreakService.swift' }
if streak_service.nil?
  streak_service = project.new(Xcodeproj::Project::Object::PBXFileReference)
  streak_service.path = 'ductiva/HabitStreakService.swift'
  streak_service.name = 'HabitStreakService.swift'
  streak_service.source_tree = '<group>'
  project.main_group.children << streak_service
end
unless widgets_target.source_build_phase.files_references.include?(streak_service)
  widgets_target.source_build_phase.add_file_reference(streak_service)
end

project.save
puts "Added files to ductivaWidgets target."
