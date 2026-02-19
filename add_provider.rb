require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }
widgets_group = project.main_group.find_subpath('ductivaWidgets', true)

# Add HabitTimelineProvider.swift to ductivaWidgets target
provider = project.files.find { |f| f.path == 'ductivaWidgets/HabitTimelineProvider.swift' }
if provider.nil?
  provider = project.new(Xcodeproj::Project::Object::PBXFileReference)
  provider.path = 'ductivaWidgets/HabitTimelineProvider.swift'
  provider.name = 'HabitTimelineProvider.swift'
  provider.source_tree = '<group>'
  project.main_group.children << provider
end

unless widgets_target.source_build_phase.files_references.include?(provider)
  widgets_target.source_build_phase.add_file_reference(provider)
end

project.save