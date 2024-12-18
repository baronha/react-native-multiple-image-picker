require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "MultipleImagePicker"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/baronha/react-native-multiple-image-picker.git", :tag => "#{s.version}" }

  s.source_files = [
    # Implementation (Swift)
    "ios/**/*.{swift}",
    # Autolinking/Registration (Objective-C++)
    "ios/**/*.{m,mm}",
    # Implementation (C++ objects)
    "cpp/**/*.{hpp,cpp}",
  ]

  s.resource_bundles = {
    "MultipleImagePicker" => ["ios/Assets.xcassets"]
  }


  s.dependency "HXPhotoPicker/Picker", "4.2.4"
  s.dependency "HXPhotoPicker/Camera/Lite", "4.2.4"
  s.dependency "HXPhotoPicker/Editor", "4.2.4"

  s.pod_target_xcconfig = {
    # C++ compiler flags, mainly for folly.
    "CLANG_CXX_LANGUAGE_STANDARD" => "c++20",
    "GCC_PREPROCESSOR_DEFINITIONS" => "$(inherited) FOLLY_NO_CONFIG FOLLY_CFG_NO_COROUTINES FOLLY_MOBILE"
  }

  if ENV["USE_FRAMEWORKS"]
    s.dependency "React-Core"
    add_dependency(s, "React-jsinspector", :framework_name => "jsinspector_modern")
    add_dependency(s, "React-rendererconsistency", :framework_name => "React_rendererconsistency")
  end

  load 'nitrogen/generated/ios/MultipleImagePicker+autolinking.rb'

  add_nitrogen_files(s)

  s.dependency 'React-jsi'
  s.dependency 'React-callinvoker'

  install_modules_dependencies(s)
end