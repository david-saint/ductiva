require 'xcodeproj'

project_path = 'ductiva.xcodeproj'
project = Xcodeproj::Project.open(project_path)
widgets_target = project.targets.find { |t| t.name == 'ductivaWidgets' }

modifier = project.files.find { |f| f.path == 'ductivaWidgets/WidgetLiquidGlassModifier.swift' }
if modifier.nil?
  modifier = project.new(Xcodeproj::Project::Object::PBXFileReference)
  modifier.path = 'ductivaWidgets/WidgetLiquidGlassModifier.swift'
  modifier.name = 'WidgetLiquidGlassModifier.swift'
  modifier.source_tree = '<group>'
  project.main_group.children << modifier
end
unless widgets_target.source_build_phase.files_references.include?(modifier)
  widgets_target.source_build_phase.add_file_reference(modifier)
end

project.save