Pod::Spec.new do |s|
    s.name             = 'InAppTools'
    s.version          = '0.2.0'
    s.summary          = "InAppTools is a library written in Swift that let's you easily add mobile users to your mailing lists."
  
    s.homepage         = 'https://github.com/dhennessy/inapptools-ios-sdk'
    s.license          = { :type => 'MIT', :file => 'LICENSE.md' }
    s.author           = { 'Denis Hennessy' => 'denis@peerassembly.com' }
    s.source           = { :git => 'https://github.com/dhennessy/inapptools-ios-sdk.git', :tag => s.version.to_s }
  
    s.ios.deployment_target = '15.0'
    s.swift_version = '5.0'
  
    s.source_files = 'Sources/InAppTools/**/*'
  end
