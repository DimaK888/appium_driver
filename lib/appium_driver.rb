require 'appium_lib'
require 'pry-byebug'
require 'socket'
require 'timeout'
require 'yaml'

include Extensions::Android::AVDManager

gem_directory = Gem::Specification.find_by_name("appium_driver").gem_dir
Dir["#{gem_directory}/lib/appium_driver/**/*.rb"].each { |file| require file }

module AppiumDriver
  class << self
    attr_accessor :status, :threads


    def load_settings(opts = {})
      raise 'opts must be a hash' unless opts.is_a? Hash
      raise 'opts must not be empty' if opts.empty?



    end

    def run
      ENV['TEST_ENV_NUMBER']
    end


  end
end


