require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

# Find StealthCeramicTheme.swift and HabitCompletionRingView.swift
theme = project.files.find { |f| f.path == 'ductiva/StealthCeramicTheme.swift' }
if theme.nil?
  theme = project.new(Xcodeproj::Project::Object::PBXFileReference)
  theme.path = 'ductiva/StealthCeramicTheme.swift'
  theme.name = 'StealthCeramicTheme.swift'
  theme.source_tree = '<group>'
  project.main_group.children << theme
end
unless widgets_target.source_build_phase.files_references.include?(theme)
  widgets_target.source_build_phase.add_file_reference(theme)
end

ring = project.files.find { |f| f.path == 'ductiva/HabitCompletionRingView.swift' }
if ring.nil?
  ring = project.new(Xcodeproj::Project::Object::PBXFileReference)
  ring.path = 'ductiva/HabitCompletionRingView.swift'
  ring.name = 'HabitCompletionRingView.swift'
  ring.source_tree = '<group>'
  project.main_group.children << ring
end
unless widgets_target.source_build_phase.files_references.include?(ring)
  widgets_target.source_build_phase.add_file_reference(ring)
end

project.save