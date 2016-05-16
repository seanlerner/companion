Gem::Specification.new do |s|
  s.name    = 'companion'
  s.version = '0.0.0'
  s.date    = '2016-05-11'
  s.executables = ['companion']
  s.authors = ['Sean Lerner']
  s.email = ['sean@smallcity.ca']
  s.summary = 'Companion evaluates and displays your code as you edit.'
  s.description = 'Companion evaluates and displays your code as you edit. It displays your method return values, variables, and errors.'
  s.homepage = 'https://gitlab.com/seanlerner/companion'
  s.licenses = ['MIT']
  s.files    = ['lib/companion.rb']
  s.add_runtime_dependency 'colorize', '~> 0'
  s.add_runtime_dependency 'curses', '~> 0'
  s.add_runtime_dependency 'diffy', '~> 0'
  s.add_runtime_dependency 'filewatcher', '~> 0'
  s.add_runtime_dependency 'json', '~> 0'
  s.add_runtime_dependency 'titleize', '~> 0'
  s.add_development_dependency 'awesome_print', '~> 0'
end
