Pod::Spec.new do |s|
  s.name         = "SSAccessibility"
  s.version      = "0.0.1"
  s.summary      = "iOS Accessibility helpers."
  s.homepage     = "https://github.com/splinesoft/SSAccessibility"
  s.license      = { :type => 'MIT', :file => 'LICENSE'  }
  s.author       = { "Jonathan Hersh" => "jon@her.sh" }
  s.source       = { :git => "https://github.com/splinesoft/SSAccessibility.git", :tag => s.version.to_s }
  s.platform     = :ios, '6.0'
  s.requires_arc = true
  s.source_files = 'SSAccessibility/*.{h,m}'
  s.frameworks   = ['Foundation', 'AudioToolbox'] 
  s.dependency 'MSWeakTimer'
end
