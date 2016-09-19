#
# Be sure to run `pod lib lint PagedAlertController.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'PagedAlertController'
  s.version          = '0.1.6'
  s.summary          = 'An alert like paged controller with custom content'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      =  "Provides an Alert style embeded in a UIPageViewController with a data source and delegate protocol for configuration and response."
  s.homepage         = 'https://github.com/DanielCardonaRojas/PagedAlertControllerPod'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Daniel Cardona Rojas' => 'd.cardona.rojas@gmail.com' }
  s.source           = { :git => 'https://github.com/DanielCardonaRojas/PagedAlertControllerPod.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '7.0'

  s.source_files = 'PagedAlertController/Classes/**/*.{h,m}'
  #s.resources = ["PagedAlertController/Classes/PagedAlertView.xib"]
  
   s.resource_bundles = {
     'PagedAlertController' => ['PagedAlertController/Classes/PagedAlertView.xib'],
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
