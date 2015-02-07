Pod::Spec.new do |s|
  s.name             = "SPXDataSources"
  s.version          = "1.0.0"
  s.summary          = "My data sources implementation."
  s.homepage         = "https://github.com/shaps80/SPXDataSources"
  s.license          = 'MIT'
  s.author           = { "Shaps Mohsenin" => "shapsuk@me.com" }
  s.source           = { :git => "https://github.com/shaps80/SPXDataSources.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/shaps'
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Pod/Classes/**/*'
  s.dependency 'SPXDefines'
end
