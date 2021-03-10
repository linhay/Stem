Pod::Spec.new do |spec|

    spec.name        = "Stem"
    spec.version     = "0.0.35"
    spec.summary     = "A Cocoa library."

    spec.description = <<-DESC
    Template is a powerful and pure Swift implemented library.
    DESC

    spec.homepage    = "https://github.com/linhay/Stem"
    spec.screenshots = ""

    spec.license     = { :type => "MIT", :file => "LICENSE" }

    spec.authors     = { "linhey" => "is.linhey@outlook.com" }
    spec.source      = { :git => "https://github.com/linhay/Stem.git", :tag => spec.version }

    spec.swift_version = "4.2"
    spec.swift_versions = ['4.0', '4.2', '5.0']

    spec.requires_arc = true
    
    spec.ios.deployment_target     = "11.0"
    spec.tvos.deployment_target    = "10.0"
    spec.osx.deployment_target     = "10.12"
    spec.watchos.deployment_target = "3.0"

    subspecs = {}

    subspecs['Core'] = Proc.new { |sp|
        sp.tvos.deployment_target    = "10.0"
        sp.ios.deployment_target     = "11.0"
        sp.osx.deployment_target     = "10.12"
        sp.watchos.deployment_target = "3.0"
    }
    
    subspecs['STUIKit'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/UIKit'
        sp.dependency 'Stem/CrossPlatform'
        sp.ios.deployment_target     = "11.0"
    }

    subspecs['CrossPlatform'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.ios.deployment_target     = "11.0"
        sp.osx.deployment_target     = "10.12"
    }

    subspecs['UIKit'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/CrossPlatform'
        sp.ios.deployment_target     = "11.0"
    }

    subspecs.each do |name, callback|
        spec.subspec name do |sp|
            callback.call(sp)
            sp.source_files = [
            'Sources/' + name + '/*.swift',
            'Sources/' + name + '/**/*.swift',
            'Sources/' + name + '/**/**/*.swift',
            'Sources/' + name + '/**/**/**/*.swift'
            ]
        end
    end

end
