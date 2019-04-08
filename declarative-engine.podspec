#
# Be sure to run `pod lib lint declarative-engine.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'declarative-engine'
  s.version          = '0.1.0'
  s.summary          = 'a bare-bones declarative engine inspired by graphql'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
It is no secret that I am a huge fan of GraphQL. But I tend to get lots of push back when suggesting it as a solution to a problem. The pushback is always related to not wanting to learn a new query language and type system. Another argument is for not wanting to bring in huge libraries.

This project is an attempt at putting those arguments to rest by extracting the declarative -> imperative pattern that we all love so much and keeping it dead simple.
                       DESC

  s.homepage         = 'https://github.com/brysgo/declarative-engine-objc'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Bryan Goldstein' => 'brysgo@gmail.com' }
  s.source           = { :git => 'https://github.com/brysgo/declarative-engine-objc.git', :tag => s.version.to_s }
   s.social_media_url = 'https://twitter.com/brysgo'

  s.ios.deployment_target = '8.0'

  s.source_files = 'declarative-engine/Classes/**/*'
  
  # s.resource_bundles = {
  #   'declarative-engine' => ['declarative-engine/Assets/*.png']
  # }

  s.public_header_files = 'declarative-engine/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
