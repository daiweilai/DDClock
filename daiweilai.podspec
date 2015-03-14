Pod::Spec.new do |s|
    s.name = '[DDClock]'
    s.version = '0.1'
    s.license = 'Apache License'
    s.summary = ''
    s.homepage = 'https://github.com/daiweilai/DDClock'
    s.description = 'A super simple and beautiful and high-efficiency IOS clock widget. Drawing views using Quartz 2D Completely.'
    s.author = {'David Day' =&gt; 'daiweilai@foxmail.com' }
    s.source = { :git =&gt; 'https://github.com/daiweilai/DDClock.git', :tag =&gt; '0.1' }
    s.platform = :ios,'5.0'
    s.source_files = 'DDClock'
    s.requires_arc = true	
    s.ios.deployment_target = '7.1'
    s.social_media_url = 'http://www.cnblogs.com/daiweilai/'
end
