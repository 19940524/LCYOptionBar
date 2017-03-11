
Pod::Spec.new do |s|
  s.name             = "LCYOptionBar"
  s.version          = "0.0.1"
  s.summary          = "一个选项栏"

  s.description      = <<-DESC
                        here is description.
                       DESC

  s.homepage         = "https://github.com/19940524/LCYOptionBar"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = {  "LCY" => "1664880373@qq.com" }
  s.source           = { :git => "https://github.com/19940524/LCYOptionBar.git", :tag => "0.0.1" }
 

  s.ios.deployment_target = '8.0'

  s.source_files = 'Class/**/*'
  #s.resource_bundles = {
  #  'CFALibrary' => ['CFALibrary/Assets/*.png']
  #}

  # s.public_header_files = 'Pod/Class/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
