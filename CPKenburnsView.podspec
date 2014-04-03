Pod::Spec.new do |s|
  s.name         = "CPKenburnsView"
  s.version      = "0.0.1"
  s.summary      = "CPKenburnsView is kenburn effects imageView"
  s.homepage     = "http://www.muukii.me"
  # s.screenshots  = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.author             = { "muukii" => "muukii.muukii@gmail.com" }
  s.platform     = :ios
  s.platform     = :ios, '7.0'
  s.source       = { :git => "https://github.com/muukii0803/CPKenburnsImageView.git", :tag => "0.0.1" }

  s.source_files  = 'CPKenburnsView/**/*.{h,m}'
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = 'SomeFramework'
  # s.frameworks = 'SomeFramework', 'AnotherFramework'

  # s.library   = 'iconv'
  # s.libraries = 'iconv', 'xml2'


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  # s.requires_arc = true

  # s.xcconfig = { 'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2' }
  # s.dependency 'JSONKit', '~> 1.4'

end
