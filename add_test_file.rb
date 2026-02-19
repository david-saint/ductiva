require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

tests_target = project.targets.find { |t| t.name == 'ductivaTests' }
group = project.main_group.find_subpath('ductivaTests', true)

tests_swift = group.find_file_by_path('SharedDataTests.swift')
unless tests_swift
  tests_swift = group.new_file('SharedDataTests.swift')
end

unless tests_target.source_build_phase.files_references.include?(tests_swift)
  tests_target.source_build_phase.add_file_reference(tests_swift)
end

project.save
puts "Added SharedDataTests.swift to target"