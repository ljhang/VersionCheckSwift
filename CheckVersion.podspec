#
#  Be sure to run `pod spec lint CheckVersion.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|


  s.name         = "CheckVersion"
  
  s.version      = "1.0.3"
  
  s.summary      = "A line of code checks Whether the app needs to be updated."

  s.homepage     = "https://github.com/ljhang/VersionCheckSwift"

  s.license      = "MIT"

  s.author       = { "ljhang" => "ljhang1@163.com" }
  
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/ljhang/VersionCheckSwift.git", :tag => "1.0.3" }

  s.source_files  = "CheckVersion/*.swift"

  s.frameworks = "Foundation", "UIKit", "StoreKit"

  s.requires_arc = true

end
