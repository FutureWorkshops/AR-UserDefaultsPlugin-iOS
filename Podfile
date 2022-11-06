source 'https://cdn.cocoapods.org/'
source 'https://github.com/FutureWorkshops/MWPodspecs.git'

workspace 'UserDefaults'
platform :ios, '15.0'

inhibit_all_warnings!
use_frameworks!

project 'UserDefaults/UserDefaults.xcodeproj'
project 'UserDefaultsPlugin/UserDefaultsPlugin.xcodeproj'

abstract_target 'MobileWorkflow' do
  pod 'MobileWorkflow', '~> 2.1.6'

  target 'UserDefaults' do
    project 'UserDefaults/UserDefaults.xcodeproj'
    pod 'UserDefaultsPlugin', path: 'UserDefaultsPlugin.podspec'

    target 'UserDefaultsTests' do
      inherit! :search_paths
    end
  end

  target 'UserDefaultsPlugin' do
    project 'UserDefaultsPlugin/UserDefaultsPlugin.xcodeproj'

    target 'UserDefaultsPluginTests' do
      inherit! :search_paths
    end
  end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ""
        config.build_settings['BUILD_LIBRARY_FOR_DISTRIBUTION'] = 'YES'
    end
  end
end

