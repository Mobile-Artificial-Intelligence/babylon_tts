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

  s.source           = { :path => '.' }
  s.vendored_libraries = 'libbabylon.dylib', 'llibonnxruntime.dylib', 'libonnxruntime.1.18.1.dylib'
  s.dependency 'FlutterMacOS'

  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
