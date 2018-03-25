# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'Todoey' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Todoey
  pod 'RealmSwift'
  pod 'SwipeCellKit'
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = false
        end
    end
end
