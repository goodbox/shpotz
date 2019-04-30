# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'goodspots' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!


  
  pod 'Alamofire', '~> 4.8.1'
  
  pod 'AlamofireImage', '~> 3.5'
  
  # pod 'XCGLogger', '~> 4.0'
  
  pod 'SwiftyJSON', '~> 4.0'
  
  
  pod 'GoogleMaps'
  pod 'GooglePlaces'
  
  # pod 'FBSDKCoreKit', '~> 4.38.0'
  # pod 'FBSDKLoginKit', '~> 4.38.0'
  #pod 'FBSDKShareKit'
  
  pod 'FacebookCore'
  pod 'FacebookLogin'
  #pod 'FacebookShare'
  
  # pod 'PopupDialog', '~> 0.9.0'
  
  # Pods for Spots
  # pod 'Material'
  # pod 'Motion'
  
  # pod 'MaterialComponents'
  pod 'MaterialComponents/Buttons'
  pod 'MaterialComponents/TextFields'
  pod 'MaterialComponents/Palettes'
  
  # image picker pods
  pod 'ImagePicker', :git => 'https://github.com/appsailor/ImagePicker.git', :branch => 'feature/Swift-4.2'
  # pod 'ImagePicker', '~> 3.0.0'
  pod 'Lightbox'
  #pod 'Sugar', git: 'https://github.com/hyperoslo/Sugar.git'
  pod 'Hue'
  
  #xl actioncontroller
  pod 'XLActionController'
  pod 'XLActionController/Twitter'
  
  # pod 'SKPhotoBrowser'
  
  #AXPhotoViewer pods
  #pod 'Reveal-SDK'
  
  # Loading spinner
  #pod 'DRPLoadingSpinner'
  
  # AXPhotoViewer
  #pod 'AXPhotoViewer'

  #reachability
  # pod 'Reachability'

  # pod 'Serrata'

  target 'goodspotsTests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  
  post_install do |installer|
      installer.pods_project.targets.each do |target|
          # Cache pod does not accept optimization level '-O', causing Bus 10 error. Use '-Osize' or '-Onone'
          if target.name == 'Cache'
              target.build_configurations.each do |config|
                  level = '-Osize'
                  config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = level
                  puts "Set #{target.name} #{config.name} to Optimization Level #{level}"
              end
          end
      end
  end
  
  #post_install do |installer|
  #  installer.pods_project.targets.each do |target|
  #    target.build_configurations.each do |config|
  #      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '10.3.3'
  #    end
  #  end
  #end

end
