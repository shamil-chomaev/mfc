# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end

target 'mfc' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for mfc
#pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'Firebase/Storage'


pod 'FirebaseFirestoreSwift'

  target 'mfcTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mfcUITests' do
    # Pods for testing
  end

end
