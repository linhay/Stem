Pod::Spec.new do |s|

    s.name         = "Template"
    s.version      = "0.0.30"
    s.summary      = "A Template library."

    s.description  = <<-DESC
    Template is a powerful and pure Swift implemented library.
    DESC

    s.homepage     = "https://github.com/linhay/pod_template"
    s.screenshots  = ""

    s.license      = { :type => "MIT", :file => "LICENSE" }

    s.authors            = { "linhey" => "is.linhey@outlook.com" }
    s.social_media_url   = "https://twitter.com/is.linhey"
    s.source             = { :git => "https://github.com/linhay/Stem.git", :tag => s.version }

    s.swift_version = "4.2"
    s.swift_versions = ['4.0', '4.2', '5.0']

    s.ios.deployment_target = "10.0"
    # s.tvos.deployment_target = "10.0"
    # s.osx.deployment_target = "10.12"
    # s.watchos.deployment_target = "3.0"


    # s.default_subspecs = "Foundation"
    s.requires_arc = true

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

        subspec_names = ['Coder',
        'Collections',
        'Custom',
        'Date',
        'Dispatch',
        'Fundamentals',
        'NSObject',
        'pre-release']

        for name in subspec_names
            ss.subspec name do |sss|
                path = base_path + name
                sss.source_files = [path + '/**/*.swift', path + '/*.swift']
            end
        end

        ss.subspec 'String' do |sss|
            sss.dependency 'Stem/Foundation/Fundamentals'
            path = base_path + 'String'
            sss.source_files = [path + '/**/*.swift', path + '/*.swift']
        end

        ss.subspec 'Custom' do |sss|
            path = base_path + 'Custom'
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

        subspec_names = ['Application',
        'Color',
        'Control',
        'Custom',
        'Font',
        'GestureRecognizer',
        'Image',
        'ImageView',
        'InputView',
        'Label',
        'ListView',
        'UIDevice',
        'View',
        'ViewController',
        'NavigationBar',
        'NSLayoutConstraint',
        'Storyboard',
        'AttributedString']

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

    s.subspec 'WebKit' do |ss|
        base_path = 'Sources/WebKit/'
        ss.source_files = [base_path + '*.swift']
        ss.frameworks = ['WebKit']
        ss.dependency 'Stem/Core'

        ss.ios.deployment_target     = '8.0'
        ss.osx.deployment_target     = '10.10'
    end


end
