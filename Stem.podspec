Pod::Spec.new do |s|
    s.name             = 'Stem'
    s.version          = '0.0.28'
    s.summary          = 'A set of useful categories for Foundation and UIKit.'
    s.homepage         = 'https://github.com/linhay/Stem.git'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'lin' => 'is.linhay@outlook.com' }
    s.source = { :git => 'https://github.com/linhay/Stem.git', :tag => s.version.to_s }

    s.swift_version = "4.2"
    s.swift_versions = ['4.0', '4.2', '5.0']

    # s.default_subspecs = "UIKit"

    s.requires_arc = true

    s.ios.deployment_target     = '8.0'
    s.osx.deployment_target     = '10.10'
    s.tvos.deployment_target    = '9.0'
    s.watchos.deployment_target = '2.0'

    s.subspec 'Core' do |ss|
        ss.source_files = ['Sources/Core/*.swift']
    end

    s.subspec 'Runtime' do |ss|
        ss.source_files = ['Sources/Runtime/*.swift']
    end

    s.subspec 'Foundation' do |ss|
        base_path = 'Sources/Foundation/'

        ss.frameworks = ['Foundation']
        ss.dependency 'Stem/Core'
        ss.ios.deployment_target     = '8.0'
        ss.osx.deployment_target     = '10.10'

        subspec_names = ['Coder', 'Collections', 'Custom', 'Date',
                         'Dispatch', 'Fundamentals', 'NSObject',
                         'pre-release']

        for name in subspec_names
            ss.subspec name do |sss|
                path = base_path + name
                sss.source_files = [path + '/**/*.swift', path + '/*.swift']
            end
        end

        ss.subspec 'String' do |sss|
            sss.dependency 'Stem/Foundation/Fundamentals'
            path = base_path + name
            sss.source_files = [path + '/**/*.swift', path + '/*.swift']
        end

        ss.subspec 'Custom' do |sss|
            sss.dependency 'Stem/Foundation/String'
            path = base_path + name
            sss.source_files = [path + '/**/*.swift', path + '/*.swift']
        end

    end

    s.subspec 'UIKit' do |ss|
        base_path = 'Sources/UIKit/'
        ss.frameworks = ['Foundation', 'UIKit']
        ss.dependency 'Stem/Core'
        ss.dependency 'Stem/Runtime'
        ss.dependency 'Stem/Foundation/NSObject'
        ss.dependency 'Stem/Foundation/Fundamentals'
        ss.ios.deployment_target = '8.0'

        subspec_names = ['Application', 'Color', 'Control', 'Custom',
                         'Font', 'GestureRecognizer', 'Image',
                         'ImageView', 'InputView', 'Label', 'ListView',
                         'UIDevice', 'View', 'ViewController',
                         'NavigationBar', 'NSLayoutConstraint', 'Storyboard', 'AttributedString']

        for name in subspec_names
            ss.subspec name do |sss|
                path = base_path + name
                sss.source_files = [path + '/**/*.swift', path + '/*.swift']
            end
        end

    end

    s.subspec 'AVKit' do |ss|
        base_path = 'Sources/AVKit/'
        ss.source_files = [base_path + '*.swift']
        ss.frameworks = ['AVFoundation', 'AVKit']
        ss.dependency 'Stem/Core'

        ss.ios.deployment_target     = '8.0'
    end

end
