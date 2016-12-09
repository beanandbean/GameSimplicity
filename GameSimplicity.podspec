#
# Be sure to run `pod lib lint GameSimplicity.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'GameSimplicity'
  s.version          = '0.0.2'
  s.summary          = 'GameSimplicity, a simple iOS game builder'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
GameSimplicity, a simple iOS game builder that let you create a mini-game from scratch at publish-standard with just a few lines of code.
                       DESC

  s.homepage         = 'https://github.com/beanandbean/GameSimplicity'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'beanandbean' => 'wangsw.a@gmail.com' }
  s.source           = { :git => 'https://github.com/beanandbean/GameSimplicity.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'GameSimplicity/Classes/**/*'
  
  # s.resource_bundles = {
  #   'GameSimplicity' => ['GameSimplicity/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
