require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }
group = project.main_group.find_subpath('ductivaWidgets', true)

widgets_swift = group.find_file_by_path('ductivaWidgets.swift')
unless widgets_swift
  widgets_swift = group.new_file('ductivaWidgets.swift')
end

unless widgets_target.source_build_phase.files_references.include?(widgets_swift)
  widgets_target.source_build_phase.add_file_reference(widgets_swift)
end

project.save
puts "Added ductivaWidgets.swift to target"