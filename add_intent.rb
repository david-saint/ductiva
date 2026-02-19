require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }
widgets_group = project.main_group.find_subpath('ductivaWidgets', true)

# Add SharedContainer to ductivaWidgets target
shared_container = project.files.find { |f| f.path == 'ductiva/SharedContainer.swift' }
if shared_container.nil?
  shared_container = project.new(Xcodeproj::Project::Object::PBXFileReference)
  shared_container.path = 'ductiva/SharedContainer.swift'
  shared_container.name = 'SharedContainer.swift'
  shared_container.source_tree = '<group>'
  project.main_group.children << shared_container
end

unless widgets_target.source_build_phase.files_references.include?(shared_container)
  widgets_target.source_build_phase.add_file_reference(shared_container)
end

# Add HabitSelectionIntent to ductivaWidgets target
intent = project.files.find { |f| f.path == 'ductivaWidgets/HabitSelectionIntent.swift' }
if intent.nil?
  intent = project.new(Xcodeproj::Project::Object::PBXFileReference)
  intent.path = 'ductivaWidgets/HabitSelectionIntent.swift'
  intent.name = 'HabitSelectionIntent.swift'
  intent.source_tree = '<group>'
  project.main_group.children << intent
end

unless widgets_target.source_build_phase.files_references.include?(intent)
  widgets_target.source_build_phase.add_file_reference(intent)
end

project.save