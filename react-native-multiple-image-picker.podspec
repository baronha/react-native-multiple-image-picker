require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

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

  s.resource_bundles = { 'MultipleImagePicker' => ['ios/**/*.xib'] }
  s.resources = 'ios/MultipleImagePicker.bundle'

  s.dependency "React-Core"
  s.dependency "TLPhotoPicker"
      
end
