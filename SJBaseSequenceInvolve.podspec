Pod::Spec.new do |s|
  s.name         = 'SJBaseSequenceInvolve'
  s.version      = '3.7.7.1'
  s.summary      = 'video player.'
  s.description  = 'https://github.com/changsanjiang/SJBaseSequenceInvolve/blob/master/README.md'
  s.homepage     = 'https://github.com/changsanjiang/SJBaseSequenceInvolve'
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author       = { 'SanJiang' => 'changsanjiang@gmail.com' }
  s.platform     = :ios, '12.0'
  s.source       = { :git => 'https://github.com/KyleWhale/SJBaseSequenceInvolve.git', :tag => "v#{s.version}" }
  s.frameworks  = "UIKit", "AVFoundation"
  s.requires_arc = true

  s.source_files = 'SJBaseSequenceInvolve/*.{h,m}'
  s.default_subspecs = 'Common', 'SequenceInvolve'
  
  s.subspec 'Common' do |ss|
    ss.source_files = 'SJBaseSequenceInvolve/Common/**/*.{h,m}'
    ss.dependency 'SJBaseSequenceInvolve/ResourceLoader'
  end
  
  s.subspec 'ResourceLoader' do |ss|
    ss.source_files = 'SJBaseSequenceInvolve/ResourceLoader/*.{h,m}'
    ss.resources = 'SJBaseSequenceInvolve/ResourceLoader/SJBaseSequenceInvolveResources.bundle'
  end
  
  s.subspec 'SequenceInvolve' do |ss|
      ss.source_files = 'SJBaseSequenceInvolve/SequenceInvolve/**/*.{h,m}'
      ss.dependency 'SJBaseSequenceInvolve/Common'
  end
  
  s.dependency 'Masonry'
  s.dependency 'SJUIKit/AttributesFactory', '>= 0.0.0.38'
  s.dependency 'SJUIKit/ObserverHelper'
  s.dependency 'SJUIKit/Queues'
  s.dependency 'SJUIKit/SQLite3'
end
