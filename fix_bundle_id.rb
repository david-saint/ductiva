require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }
widgets_target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', 'dev.davidsaint.ductiva.ductivaWidgets')

project.save
puts "Fixed bundle identifier for ductivaWidgets"