Pod::Spec.new do |s|
  s.name             = "ARDetector"
  s.version          = "0.1.1"
  s.summary          = "CIDetector and AVCaptureOutput categories. With face, rectangle, QR Code, text detectors and blocks."
  s.homepage         = "https://github.com/alexruperez/ARDetector"
  s.screenshots     = "https://raw.githubusercontent.com/alexruperez/ARDetector/master/screenshot.jpg"
  s.license          = 'MIT'
  s.author           = { "alexruperez" => "contact@alexruperez.com" }
  s.source           = { :git => "https://github.com/alexruperez/ARDetector.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alexruperez'

  s.platform     = :ios, '8.0'
  s.requires_arc = true
  
  s.source_files = 'ARDetector/*.{h,m,swift}'
  
  s.frameworks = 'UIKit', 'CoreImage' 
end
