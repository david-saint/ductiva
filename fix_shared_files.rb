require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

files_to_remove = ['HabitCalendarViewModel.swift', 'HabitModel.swift']

widgets_target.source_build_phase.files_references.each do |ref|
  if files_to_remove.include?(ref.name)
    widgets_target.source_build_phase.remove_file_reference(ref)
    ref.remove_from_project
    puts "Removed #{ref.name}"
  end
end

project.save