require "json"

package = JSON.parse(File.read(File.join(__dir__, "package.json")))

Pod::Spec.new do |s|
  s.name         = "react-native-multiple-image-picker"
  s.version      = package["version"]
  s.summary      = package["description"]
  s.homepage     = package["homepage"]
  s.license      = package["license"]
  s.authors      = package["author"]

  s.platforms    = { :ios => min_ios_version_supported }
  s.source       = { :git => "https://github.com/baronha/react-native-multiple-image-picker.git", :tag => "#{s.version}" }

  s.source_files = "ios/**/*.{h,m,mm,swift}"

  # s.dependency "HXPhotoPicker", "4.1.7"

  s.dependency "HXPhotoPicker/Picker/Lite", "4.1.7"
  # s.dependency "HXPhotoPicker/Picker", "4.1.7"
  # s.dependency "HXPhotoPicker/Picker", "4.1.7"


  install_modules_dependencies(s)
end
