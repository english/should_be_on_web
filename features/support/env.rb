require 'aruba/cucumber'
require 'methadone/cucumber'
require_relative 'file_generators'

ENV['PATH'] = "#{File.expand_path(File.dirname(__FILE__) + '/../../bin')}#{File::PATH_SEPARATOR}#{ENV['PATH']}"
LIB_DIR = File.join(File.expand_path(File.dirname(__FILE__)),'..','..','lib')

Before do
  # Using "announce" causes massive warnings on 1.9.2
  @puts = true
  @original_rubylib = ENV['RUBYLIB']
  ENV['RUBYLIB'] = LIB_DIR + File::PATH_SEPARATOR + ENV['RUBYLIB'].to_s
  @aruba_timeout_seconds = 10 if RUBY_PLATFORM == 'java'
end

After do
  ENV['RUBYLIB'] = @original_rubylib
end

Aruba.configure do |config|
  config.before_cmd do |cmd|
    set_env('JRUBY_OPTS', "-X-C --1.9") # disable JIT since these processes are so short lived & force 1.9
    set_env('JAVA_OPTS', "") # stop aruba using 32bit JVM
  end
end if RUBY_PLATFORM == 'java'

World(FileGenerators)
