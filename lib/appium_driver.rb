require 'socket'
require 'timeout'
require 'yaml'

gem_directory = Gem::Specification.find_by_name("appium_driver").gem_dir
Dir["#{gem_directory}/lib/**/*.rb"].each { |file| require file }

::SDK = YAML.safe_load(File.read('lib/android/sdk_version.yml'))

include AppiumDriver
