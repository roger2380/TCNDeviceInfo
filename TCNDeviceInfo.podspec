#
# Be sure to run `pod lib lint TCNDeviceInfo.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TCNDeviceInfo'
  s.version          = '0.0.03'
  s.summary          = 'get info about device,system,app.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
提供和设备、系统、应用相关的信息,例如系统版本,应用版本,应用的包名等信息.
                       DESC

  s.homepage         = 'http://git.1kxun.com/ios/TCNDeviceInfo'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '周高举' => 'zgj@shtruecolor.com' }
  s.source           = { :git => 'ssh://git@git.1kxun.com:9922/ios/TCNDeviceInfo.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'TCNDeviceInfo/Classes/**/*'
  
  # s.resource_bundles = {
  #   'TCNDeviceInfo' => ['TCNDeviceInfo/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'CoreTelephony', 'AdSupport', 'SystemConfiguration'
  s.dependency 'TCNDataEncoding', '~> 0.0.2'
end
