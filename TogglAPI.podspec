Pod::Spec.new do |s|
  s.name = 'TogglAPI'
  s.version = '0.1.2'
  s.license = 'Apache 2'
  s.summary = 'Toggl API in Swift'
  s.homepage = 'https://github.com/coodly/TogglAPI'
  s.authors = { 'Jaanus Siim' => 'jaanus@coodly.com' }
  s.source = { :git => 'git@github.com:coodly/TogglAPI.git', :tag => s.version }

  s.ios.deployment_target = '10.0'

  s.source_files = 'Sources/TogglAPI/*.swift'

  s.requires_arc = true
end
