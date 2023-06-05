Pod::Spec.new do |s|
  s.name         = "Atributika"
  s.version      = "5.0.2"
  s.summary      = "Convert text with HTML tags, hashtags, mentions, links into NSAttributedString."
  s.description  = <<-DESC
    `Atributika` is an effortless to build NSAttributedString. It is able to detect HTML-like tags, links, phone numbers, hashtags, any regex or even standard ios data detectors and style them with various attributes like font, color, etc.
  DESC
  s.homepage     = "https://github.com/psharanda/Atributika"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "Pavel Sharanda" => "psharanda@gmail.com" }
  s.social_media_url   = "https://twitter.com/psharanda"
  s.swift_version = '5.1'
  s.ios.deployment_target = "11.0"
  s.osx.deployment_target = "10.13"
  s.watchos.deployment_target = "4.0"
  s.tvos.deployment_target = "11.0"
  s.source       = { :git => "https://github.com/psharanda/Atributika.git", :tag => s.version.to_s }
  s.source_files = "Sources/Core/**/*.swift"
end
