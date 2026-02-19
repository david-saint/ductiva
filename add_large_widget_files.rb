require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

files_to_add = [
  'ductiva/LargeFocusWidgetView.swift',
  'ductiva/LargeStandardWidgetView.swift',
  'ductiva/HabitCalendarGridView.swift'
]

files_to_add.each do |file_path|
  file_ref = project.files.find { |f| f.path == file_path }
  if file_ref.nil?
    file_ref = project.new(Xcodeproj::Project::Object::PBXFileReference)
    file_ref.path = file_path
    file_ref.name = File.basename(file_path)
    file_ref.source_tree = '<group>'
    project.main_group.children << file_ref
  end
  unless widgets_target.source_build_phase.files_references.include?(file_ref)
    widgets_target.source_build_phase.add_file_reference(file_ref)
  end
end

project.save
puts "Added Large widget files to ductivaWidgets target."
