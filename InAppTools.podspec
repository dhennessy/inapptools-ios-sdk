Pod::Spec.new do |s|
    s.name             = 'InAppTools'
    s.version          = '0.1.0'
    s.summary          = 'A short description of BloggerBird.'
  
    s.homepage         = 'https://github.com/dhennessy/inapptools-ios-sdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'InAppTools' => 'denis@peerassembly.com' }
    s.source           = { :git => 'https://github.com/dhennessy/inapptools-ios-sdk.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '15.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Sources/InAppTools/**/*'
  end
