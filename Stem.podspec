Pod::Spec.new do |s|
  s.name             = 'Stem'
  s.version          = '0.0.2'
  s.summary          = 'A set of useful categories for Foundation and UIKit.'
  
  
  s.homepage         = 'https://github.com/linhay/Stem.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lin' => 'is.linhay@outlook.com' }
  s.source = { :git => 'https://github.com/linhay/Stem.git', :tag => s.version.to_s }
  
  s.ios.deployment_target = '8.0'
  s.swift_version = '4.2'
  
  s.frameworks = ['UIKit']
  s.requires_arc = true
  
  s.subspec 'Core' do |ss|
    ss.source_files = 'Sources/Core/**'
  end
  
  list = [
  'Foundation',
  'CALayer',
  'CGRect',
  'TableView',
  'Color',
  'Label',
  'Font',
  'Image',
  'Control',
  'NSLayoutConstraint',
  'Application',
  'Storyboard',
  'NavigationBar',
  'TextField',
  'ViewController',
  'ImageView',
  'View',
  'Cell',
  'GestureRecognizer'
  ]
  
  for name in list
    s.subspec name do |ss|
      ss.source_files = 'Sources/' + name + '/**'
      ss.dependency 'Stem/Core'
    end
  end
  
  s.subspec 'UIButton' do |ss|
    ss.source_files = 'Sources/UIButton/**'
    ss.dependency 'Stem/Core'
    ss.dependency 'Stem/Control'
  end
  
end
