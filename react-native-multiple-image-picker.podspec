require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))
folly_compiler_flags = '-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1 -Wno-comma -Wno-shorten-64-to-32'

Pod::Spec.new do |s|
  s.name         = "react-native-multiple-image-picker"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => "10.0" }
  s.source       = { :git => "https://github.com/baronha/react-native-multiple-image-picker.git", :tag => "#{s.version}" }
  s.swift_version = '5.0'

  s.source_files = "ios/**/*.{h,m,mm,swift,lproj}"

  s.resource_bundles = { 'MultipleImagePicker' => ['ios/**/*.{xib}'] }
  #s.resources = 'ios/MultipleImagePicker.bundle'

  s.dependency 'React-Core'
  s.dependency 'TLPhotoPicker', '2.1.9'
  s.dependency 'CropViewController', '2.6.1'

  s.subspec 'Viewer' do |vw|
    vw.name             = "Viewer"
    vw.source_files = 'ios/Viewer'
    vw.resource_bundles = { "Viewer" => "ios/Viewer/*.xcassets" }
    vw.requires_arc     = true
  end

  # Don't install the dependencies when we run `pod install` in the old architecture.
  if ENV['RCT_NEW_ARCH_ENABLED'] == '1' then
    s.compiler_flags = folly_compiler_flags + " -DRCT_NEW_ARCH_ENABLED=1"
    s.pod_target_xcconfig    = {
        "HEADER_SEARCH_PATHS" => "\"$(PODS_ROOT)/boost\"",
        "OTHER_CPLUSPLUSFLAGS" => "-DFOLLY_NO_CONFIG -DFOLLY_MOBILE=1 -DFOLLY_USE_LIBCPP=1",
        "CLANG_CXX_LANGUAGE_STANDARD" => "c++17"
    }
    
    s.dependency "React-Codegen"
    s.dependency "RCT-Folly"
    s.dependency "RCTRequired"
    s.dependency "RCTTypeSafety"
    s.dependency "ReactCommon/turbomodule/core"
  end
  
end
