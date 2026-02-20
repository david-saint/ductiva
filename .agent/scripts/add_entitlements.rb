require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

app_target = project.targets.find { |t| t.name == 'ductiva' }
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

app_target.build_configuration_list.set_setting('CODE_SIGN_ENTITLEMENTS', 'ductiva/ductiva.entitlements')
widgets_target.build_configuration_list.set_setting('CODE_SIGN_ENTITLEMENTS', 'ductivaWidgets/ductivaWidgets.entitlements')

project.save
puts "Successfully set entitlements."