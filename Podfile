source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
inhibit_all_warnings!
use_frameworks!
install! 'cocoapods', :deterministic_uuids => false

workspace 'MyApp.xcworkspace'

target 'MyApp' do
    project 'MyApp'

    # Architect
    pod 'MVVM-Swift', '1.1.0' # MVVM Architect for iOS Application.`

    # Data
    pod 'ObjectMapper', '3.3.0' # Simple JSON Object mapping written in Swift.

    # Network
    pod 'Alamofire', '4.7.3' # Elegant HTTP Networking in Swift.
    pod 'AlamofireNetworkActivityIndicator', '2.3.0' # Controls the visibility of the network activity indicator on iOS using Alamofire.

    # Utils
    pod 'SwiftLint', '0.30.1' # A tool to enforce Swift style and conventions.
    pod 'SwiftUtils', '4.2.1'
    pod 'SVProgressHUD'
    pod 'SDWebImage'
    pod 'NVActivityIndicatorView'

    # Crash reporting & beta deployment
    pod 'Crashlytics'
    pod 'Fabric'
    pod 'RealmSwift'

    # Test
#    pod 'Nimble'
#    pod 'Quick'
#    pod 'OHHTTPStubs/Swift'

    # Firebase
    pod 'Firebase/Analytics'
    pod 'Firebase/Database'
    pod 'Firebase/Storage'
    pod 'GeoFire', '~> 3.0'
    pod 'Cosmos', '~> 20.0'

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if config.name == 'Release'
                config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Owholemodule'
            end
            config.build_settings['SWIFT_VERSION'] = '4.2'
        end
        end
    end
end
