#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint babylon_tts.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'babylon_tts'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter FFI plugin project.'
  s.description      = <<-DESC
A new Flutter FFI plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Mobile Artificial Intelligence' => 'dane_madsen@hotmail.com' }
  s.dependency 'FlutterMacOS'
  s.swift_version = '5.0'

  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'

  s.frameworks = 'Foundation', 'Metal', 'MetalKit'
  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES',
    'OTHER_CFLAGS' => ['$(inherited)', '-O3', '-flto', '-fno-objc-arc'],
    'OTHER_CPLUSPLUSFLAGS' => ['$(inherited)', '-O3', '-flto', '-fno-objc-arc'],
    'GCC_PREPROCESSOR_DEFINITIONS' => ['$(inherited)', 'GGML_USE_METAL=1'],
  }
end

