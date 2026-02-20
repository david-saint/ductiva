require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

# I need to create explicit PBXFileReferences for files in 'ductiva/' 
# and add them to the widgets_target source_build_phase
files_to_add = ['ductiva/Habit.swift', 'ductiva/Item.swift', 'ductiva/HabitStore.swift', 'ductiva/HabitCalendarViewModel.swift', 'ductiva/HabitModel.swift']

files_to_add.each do |file_path|
  file_name = File.basename(file_path)
  
  # Check if reference already exists in widgets_target
  ref = project.files.find { |f| f.path == file_path || f.name == file_name }
  if ref.nil?
    ref = project.new(Xcodeproj::Project::Object::PBXFileReference)
    ref.path = file_path
    ref.name = file_name
    ref.source_tree = '<group>'
    project.main_group.children << ref
  end

  unless widgets_target.source_build_phase.files_references.include?(ref)
    widgets_target.source_build_phase.add_file_reference(ref)
    puts "Added #{file_name} to ductivaWidgets target"
  end
end

project.save
puts "Done"