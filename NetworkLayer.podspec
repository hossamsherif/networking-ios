#
# Be sure to run `pod lib lint NetworkLayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'NetworkLayer'
  s.version          = '0.1.0'
  s.summary          = 'NetworkLayer is managed network layer built up on Moya network library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
                        Built up on MoyaProvider<MultiTarget> provider
                        Providers:
                        - sending plain request via `sendRequest` which only success and failure
                        - fetching data request via `fetchData` which return success with mappable object result or failure with error
                        Features:
                        - Caching with by providing cachedResponseKey - only available for `fetchData`
                        - Retry on 401 error by passing true to shouldRetryOn401 paramter - also need to pass reauthenticate block to NL.reauthenticateBlock
                        - Progress block for uploading and downloading request to get current progress by ((Double)-> Void) block
                       DESC

  s.homepage         = 'https://github.com/hossamsherif/networking-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hossamsherif' => 'hossam.sherif21@gmail.com' }
  s.source           = { :git => 'https://github.com/hossamsherif/networking-ios.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.swift_version = '5.0'

  s.source_files = 'NetworkLayer/Classes/**/*'

  # s.resource_bundles = {
  #   'NetworkLayer' => ['NetworkLayer/Assets/*.png']
  # }

#   s.public_header_files = 'Pod/Classes/**/*.h'
   s.dependency 'Moya', '~> 14.0'
   s.dependency 'ObjectMapper'
   s.dependency 'ReachabilitySwift'
   s.dependency 'DataCache'
end
