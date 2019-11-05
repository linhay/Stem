Pod::Spec.new do |s|
    s.name             = 'Stem'
    s.version          = '0.0.27'
    s.summary          = 'A set of useful categories for Foundation and UIKit.'
    s.homepage         = 'https://github.com/linhay/Stem.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'lin' => 'is.linhay@outlook.com' }
    s.source = { :git => 'https://github.com/linhay/Stem.git', :tag => s.version.to_s }

    s.swift_version = ['4.0', '4.1', '4.2', '5.0', '5.1']

    s.requires_arc = true

    s.subspec 'Core' do |ss|
        ss.source_files = ['Sources/Core/*.swift']

        ss.ios.deployment_target = '8.0'
        ss.tvos.deployment_target = '9.0'
        ss.osx.deployment_target = '10.10'
        ss.watchos.deployment_target = '2.0'
    end

    s.subspec 'Runtime' do |ss|
        ss.source_files = ['Sources/Runtime/*.swift']

        ss.ios.deployment_target = '8.0'
        ss.tvos.deployment_target = '9.0'
        ss.osx.deployment_target = '10.10'
        ss.watchos.deployment_target = '2.0'
    end

    s.subspec 'Foundation' do |ss|
        base_path = 'Sources/Foundation/'

        ss.source_files = [base_path + '**/*.swift']
        #    ss.exclude_files = [base_path + 'Custom/**/*', base_path + 'Custom/*']

        ss.frameworks = ['Foundation']
        ss.dependency 'Stem/Core'

        ss.ios.deployment_target = '8.0'
        ss.tvos.deployment_target = '9.0'
        ss.osx.deployment_target = '10.10'
        ss.watchos.deployment_target = '2.0'
    end

    s.subspec 'UIKit' do |ss|
        base_path = 'Sources/UIKit/'

        ss.source_files = [base_path + '**/*.swift']
        #    ss.exclude_files = [base_path + 'Custom/**/*', base_path + 'Custom/*']

        ss.frameworks = ['Foundation', 'UIKit']
        ss.dependency 'Stem/Core'
        ss.dependency 'Stem/Runtime'
        ss.dependency 'Stem/Foundation'

        ss.ios.deployment_target = '8.0'
    end

    #  foundation_store = {
    #
    #  }
    #
    #  uikit_dict = {
    #    'Core' => [],
    #    'UIDevice' => ['Stem/Core'],
    #    'Foundation' => ['Stem/Core'],
    #    'CGGeometry' => ['Stem/Core'],
    #    'ListView' => ['Stem/Core'],
    #    'Color' => ['Stem/Core'],
    #    'Label' => ['Stem/Core'],
    #    'Font' => ['Stem/Core'],
    #    'Image' => ['Stem/Core'],
    #    'ImageView' => ['Stem/Core', 'Stem/Image'],
    #    'Control' => ['Stem/Core'],
    #    'NSLayoutConstraint' => ['Stem/Core'],
    #    'Application' => ['Stem/Core'],
    #    'Storyboard' => ['Stem/Core'],
    #    'PopGesture' => ['Stem/Core'],
    #    'NavigationBar' => ['Stem/Core'],
    #    'InputView' => ['Stem/Core', 'Stem/CGGeometry'],
    #    'ViewController' => ['Stem/Core'],
    #    'View' => ['Stem/Core'],
    #    'GestureRecognizer' => ['Stem/Core']
    #  }
    #
    #  dict.each { |key, value|
    #    s.subspec key do |ss|
    #      ss.source_files = ['Sources/' + key + '/**', 'Sources/' + key + '/*/**']
    #      for name in value
    #        ss.dependency name
    #      end
    #    end
    #  }

end
