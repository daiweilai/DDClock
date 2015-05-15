Pod::Spec.new do |s|
  s.name         = "DDClock"
  s.version      = "1.0.0"
  s.summary      = "A super simple and beautiful and high-performance IOS clock widget. Drawing views using Quartz 2D Completely."
  s.homepage     = "https://github.com/daiweilai/DDClock"
  s.license      = "Apache License"
  s.author       = { "David Day" => "daiweilai@gmail.com" }
  s.source       = { :git => "https://github.com/daiweilai/DDClock.git", :tag => 'v1.0.0'}
  s.source_files = "DDClock/**/*.{h,m}"
  s.requires_arc = true
  s.platform     = :ios, '7.0'
end