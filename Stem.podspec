Pod::Spec.new do |s|
  s.name             = 'Stem'
  s.version          = '0.0.1'
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
  
  s.subspec 'Foundation' do |ss|
    ss.source_files = 'Sources/Foundation/**'
  end
  
  s.subspec 'CALayer' do |ss|
    ss.source_files = 'Sources/CALayer/**'
  end
  
  s.subspec 'CGRect' do |ss|
    ss.source_files = 'Sources/CGRect/**'
  end
  
  s.subspec 'NSLayoutConstraint' do |ss|
    ss.source_files = 'Sources/NSLayoutConstraint/**'
  end
  
  s.subspec 'UIApplication' do |ss|
    ss.source_files = 'Sources/UIApplication/**'
  end
  
  s.subspec 'UIButton' do |ss|
    ss.source_files = 'Sources/UIButton/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UICell' do |ss|
    ss.source_files = 'Sources/UICell/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UIColor' do |ss|
    ss.source_files = 'Sources/UIColor/**'
  end
  
  s.subspec 'UIControl' do |ss|
    ss.source_files = 'Sources/UIControl/**'
  end
  
  s.subspec 'UIImage' do |ss|
    ss.source_files = 'Sources/UIImage/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UILabel' do |ss|
    ss.source_files = 'Sources/UILabel/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UIStoryboard' do |ss|
    ss.source_files = 'Sources/UIStoryboard/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UINavigationBar' do |ss|
    ss.source_files = 'Sources/UINavigationBar/**'
  end
  
  s.subspec 'UITextField' do |ss|
    ss.source_files = 'Sources/UITextField/**'
  end
  
  s.subspec 'UIView' do |ss|
    ss.source_files = 'Sources/UIView/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UIImageView' do |ss|
    ss.source_files = 'Sources/UIImageView/**'
    ss.dependency 'Stem/Core'
  end
  
  s.subspec 'UIViewController' do |ss|
    ss.source_files = 'Sources/UIViewController/**'
    ss.dependency 'Stem/Core'
  end
  
  
end
