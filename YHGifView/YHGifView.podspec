Pod::Spec.new do |s|
  s.name     = 'YHGifView'
  s.version  = '2.0.3'
  s.ios.deployment_target = '6.1'
  s.tvos.deployment_target = '9.0'
  s.license  = 'MIT'
  s.summary  = 'A clean and lightweight progress HUD for your iOS and tvOS app.'
  s.homepage = 'https://github.com/SVProgressHUD/SVProgressHUD'
  s.authors   = { 'Qiu HongYu' => '632244510@qq.com'}
  s.source   = { :git => 'https://github.com/YHQiu/YHGifView.git'}

  s.description = 'YHGifView is a easy use framework for gif image show'

  s.source_files = 'YHGifView/GifView/*.{h,m}'
  s.requires_arc = true
end
