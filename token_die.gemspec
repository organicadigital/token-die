require './lib/token-die/version'

Gem::Specification.new do |s|
  s.name          = 'token-die'
  s.version       = TokenDie::VERSION
  s.authors       = ['Orgânica Digital', 'Alessandro Tegner']
  s.email         = ['alessandro@organicadigital.com']
  s.summary       = 'Generate and validate time expiring tokens'
  s.description   = s.summary
  s.homepage      = 'http://organicadigital.com'
  s.license       = 'MIT'

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(spec)/}) }
  s.bindir        = 'exe'
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'parsel', '~> 0.2.0'
  s.add_development_dependency 'bundler', '>= 1.8'
  s.add_development_dependency 'rake', '>= 10.0'
  s.add_development_dependency 'rspec', '>= 3.3.0'

end