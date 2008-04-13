%w(
  rubygems rake/testtask rake/gempackagetask 
  rake/rdoctask rake/contrib/sshpublisher synthesis/task
).each {|l|require l}

task :default => :test
Rake::TestTask.new(:test) do |t|
  t.pattern = 'test/**/*_test.rb'
end

Synthesis::Task.new

Rake::RDocTask.new(:rdoc) do |t| 
  t.rdoc_files.include('README', 'COPYING', 'lib/**/*.rb') 
  t.main = 'README' 
  t.title = "Queueue" 
  t.options = ['--inline-source']
end

desc "Upload RDoc to site"
task :publish_rdoc do
  Rake::Task[:rdoc].invoke
  Rake::SshDirPublisher.new("www-data@nutrun.com", "/var/www/nutrun.com/q/rdoc", "html").upload
end

gem_spec = Gem::Specification.new do |s|
  s.name = 'queueue'
  s.version = '0.0.8'
  s.platform = Gem::Platform::RUBY
  s.summary, s.description = 'A portable AWS SQS stub'
  s.author = 'George Malamidis'
  s.email = 'george@nutrun.com'
  s.homepage = 'http://nutrun.com/q'
  s.has_rdoc = true
  s.rdoc_options += ['--quiet', '--title', 'Queueue', '--main', 'README', '--inline-source']
  s.extra_rdoc_files = ['README', 'COPYING']
  s.executables = ['queueue']
  excluded = FileList['etc/*']
  s.test_files = FileList['test/**/*_test.rb']
  s.files = FileList['**/*.rb', 'COPYING', 'README', 'Rakefile'] + s.test_files - excluded
  s.add_dependency('sinatra')
end

Rake::GemPackageTask.new(gem_spec) do |t|
  t.need_zip = false
  t.need_tar = false
end

desc "Remove gem, rdoc and log artifacts"
task :clean => [:clobber_package, :clobber_rdoc] do
  Dir['./**/*.log'].each { |f| FileUtils.rm f }
end