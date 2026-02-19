require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)

app_target = project.targets.find { |t| t.name == 'ductiva' }
widgets_target_name = 'ductivaWidgets'

# Check if target already exists
if project.targets.any? { |t| t.name == widgets_target_name }
  puts "Target #{widgets_target_name} already exists."
  exit
end

# Create the target
widgets_target = project.new_target(:app_extension, widgets_target_name, :macos)
widgets_target.build_configuration_list.set_setting('INFOPLIST_FILE', 'ductivaWidgets/Info.plist')
widgets_target.build_configuration_list.set_setting('PRODUCT_BUNDLE_IDENTIFIER', 'com.saint.ductiva.ductivaWidgets')
widgets_target.build_configuration_list.set_setting('SWIFT_VERSION', '5.0')
widgets_target.build_configuration_list.set_setting('MACOSX_DEPLOYMENT_TARGET', '14.0')
widgets_target.build_configuration_list.set_setting('SKIP_INSTALL', 'YES')
widgets_target.build_configuration_list.set_setting('PRODUCT_MODULE_NAME', widgets_target_name)
widgets_target.build_configuration_list.set_setting('PRODUCT_NAME', widgets_target_name)

# Add files to the target
group = project.main_group.find_subpath('ductivaWidgets', true)
group.set_source_tree('<group>')
group.set_path('ductivaWidgets')

bundle_swift = group.new_file('ductivaWidgetsBundle.swift')
widgets_target.source_build_phase.add_file_reference(bundle_swift)

# Add frameworks
widgetkit = project.frameworks_group.new_file('System/Library/Frameworks/WidgetKit.framework')
swiftui = project.frameworks_group.new_file('System/Library/Frameworks/SwiftUI.framework')
appintents = project.frameworks_group.new_file('System/Library/Frameworks/AppIntents.framework')

widgets_target.frameworks_build_phase.add_file_reference(widgetkit)
widgets_target.frameworks_build_phase.add_file_reference(swiftui)
widgets_target.frameworks_build_phase.add_file_reference(appintents)

# Make the app embed the extension
embed_phase = app_target.new_copy_files_build_phase('Embed Foundation Extensions')
embed_phase.symbol_dst_subfolder_spec = :plug_ins
file_ref = widgets_target.product_reference
build_file = embed_phase.add_file_reference(file_ref)
build_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy'] }

project.save
puts "Successfully added #{widgets_target_name} target."