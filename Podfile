# Uncomment the next line to define a global platform for your project
project 'Template.xcodeproj'

def setup_pod
  use_frameworks!
  pod 'Stem', :path => './Template.podspec'
  pod 'SwiftLint', :configurations => 'Debug'
end

target 'iOS' do
  platform :ios, '10.0'
  setup_pod
end

#target 'macOS' do
#  platform :macos, '10.15'
#  setup_pod
#end
#
#target 'tvOS' do
#  setup_pod
#end
