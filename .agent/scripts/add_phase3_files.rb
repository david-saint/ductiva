require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

main_target = project.targets.find { |t| t.name == 'ductiva' }
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }
tests_target = project.targets.find { |t| t.name == 'ductivaTests' }

main_group = project.main_group.find_subpath('ductiva', true)
tests_group = project.main_group.find_subpath('ductivaTests', true)

# --- Add SmallStandardWidgetView.swift to main + widgets targets ---
small_std = main_group.find_file_by_path('SmallStandardWidgetView.swift')
unless small_std
  small_std = main_group.new_file('SmallStandardWidgetView.swift')
end
unless main_target.source_build_phase.files_references.include?(small_std)
  main_target.source_build_phase.add_file_reference(small_std)
end
unless widgets_target.source_build_phase.files_references.include?(small_std)
  widgets_target.source_build_phase.add_file_reference(small_std)
end
puts "Added SmallStandardWidgetView.swift to ductiva + ductivaWidgets targets"

# --- Add SmallStandardWidgetTests.swift to tests target ---
test_file = tests_group.find_file_by_path('SmallStandardWidgetTests.swift')
unless test_file
  test_file = tests_group.new_file('SmallStandardWidgetTests.swift')
end
unless tests_target.source_build_phase.files_references.include?(test_file)
  tests_target.source_build_phase.add_file_reference(test_file)
end
puts "Added SmallStandardWidgetTests.swift to ductivaTests target"

project.save
puts "Project saved successfully"
