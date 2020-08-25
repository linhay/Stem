Pod::Spec.new do |spec|

    spec.name        = "Stem"
    spec.version     = "0.0.32"
    spec.summary     = "A Cocoa library."

    spec.description = <<-DESC
    Template is a powerful and pure Swift implemented library.
    DESC

    spec.homepage    = "https://github.com/linhay/Stem"
    spec.screenshots = ""

    spec.license     = { :type => "MIT", :file => "LICENSE" }

    spec.authors     = { "linhey" => "is.linhey@outlook.com" }
    spec.source      = { :git => "https://github.com/linhay/Stem.git", :tag => spec.version }

    spec.swift_versions = ['4.0', '4.2', '5.0', '5.1', '5.2', '5.3']

    spec.requires_arc = true

    subspecs = {}

    subspecs['STUIKit'] = Proc.new { |sp|
        sp.dependency 'Stem/UIKit'
        sp.ios.deployment_target = '11.0'
    }

    subspecs['Core'] = Proc.new { |sp|
        sp.tvos.deployment_target    = "10.0"
        sp.ios.deployment_target     = "10.0"
        sp.osx.deployment_target     = "10.15"
        sp.watchos.deployment_target = "3.0"
    }

    subspecs['NSObject'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.tvos.deployment_target    = "10.0"
        sp.ios.deployment_target     = "10.0"
        sp.osx.deployment_target     = "10.15"
        sp.watchos.deployment_target = "3.0"
    }

    subspecs['Runtime'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.tvos.deployment_target    = "10.0"
        sp.ios.deployment_target     = "10.0"
        sp.osx.deployment_target     = "10.15"
        sp.watchos.deployment_target = "3.0"
    }

    subspecs['Fundamentals'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.tvos.deployment_target    = "10.0"
        sp.ios.deployment_target     = "10.0"
        sp.osx.deployment_target     = "10.15"
        sp.watchos.deployment_target = "3.0"
    }

    subspecs['AVKit'] = Proc.new { |sp|
        sp.frameworks = ['AVFoundation']
        sp.dependency 'Stem/Core'
        sp.ios.deployment_target     = "10.0"
        sp.osx.deployment_target     = "10.15"
    }

    subspecs['CoreText'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
    }

    subspecs['Custom'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/NSObject'
    }

    subspecs['Foundation'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/Fundamentals'
    }

    subspecs['CrossPlatform'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/Runtime'
        sp.dependency 'Stem/NSObject'
        sp.dependency 'Stem/Foundation'
        sp.ios.deployment_target = '10.0'
        sp.osx.deployment_target = "10.15"
    }

    subspecs['UIKit'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
        sp.dependency 'Stem/Runtime'
        sp.dependency 'Stem/NSObject'
        sp.dependency 'Stem/Foundation'
        sp.ios.deployment_target = '10.0'
    }

    subspecs['WebKit'] = Proc.new { |sp|
        sp.dependency 'Stem/Core'
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
