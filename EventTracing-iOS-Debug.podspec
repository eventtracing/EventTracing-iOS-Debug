Pod::Spec.new do |s|
  s.name             = 'EventTracing-iOS-Debug'
  s.version          = '1.0.0'
  s.summary          = 'EventTracing-iOS-Debug'

  s.description      = <<-DESC
    EventTracing-iOS-Debug
                       DESC

  s.homepage         = 'https://github.com/EventTracing/EventTracing-iOS-Debug'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'eventtracing' => 'eventtracing@service.netease.com' }
  s.source           = { :git => 'https://github.com/EventTracing/EventTracing-iOS-Debug.git', :tag => s.version.to_s }

  s.ios.deployment_target = '11.0'
  s.module_name = 'EventTracingDebug'
  s.pod_target_xcconfig = {
    "GCC_PRECOMPILE_PREFIX_HEADER" => true,
    'CLANG_ENABLE_MODULES' => true,
    'GCC_PREPROCESSOR_DEFINITIONS' => '__MODULE_NAME__=\"EventTracing-iOS-Debug\" MODULE_NAME=@\"EventTracing-iOS-Debug\"',
  }

  s.source_files = [
    'EventTracing-iOS-Debug/Classes/**/*.{h,m,mm}'
  ]

  s.public_header_files = [
  'EventTracing-iOS-Debug/Classes/Public/*.h',
  ]
  s.resource_bundles = {
    'EventTracing-iOS-Debug' => ['EventTracing-iOS-Debug/Assets/**/*']
  }

  s.frameworks = 'UIKit'

  s.dependency 'EventTracing'
  s.dependency 'Masonry'
  s.dependency 'BlocksKit', '~> 2.2.5'
end
