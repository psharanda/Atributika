Pod::Spec.new do |s|
  s.name         = "Atributika"
  s.version      = "4.0.0"
  s.summary      = "NSAttributedString builder using HTML-like tags written in Swift"
  s.description  = <<-DESC
    Atributika is the easiest and painless way to build NSAttributedString. It is able to detect HTML-like tags, hashtags, any regex or even standard ios data detectors and style them with various attributes like font, color etc. 
  DESC
  s.homepage     = "https://github.com/psharanda/Atributika"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Pavel Sharanda" => "edvaef@gmail.com" }
  s.social_media_url   = "https://twitter.com/e2f"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/psharanda/Atributika.git", :tag => s.version.to_s }
  s.source_files  = "Sources/**/*"
end
