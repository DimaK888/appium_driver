lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'appium_driver/version'

Gem::Specification.new do |spec|
  spec.name          = 'appium_driver'
  spec.version       = AppiumDriver::VERSION
  spec.authors       = ['Dmitry Kolbin']
  spec.email         = ['kolbindmitry@gmail.com']

  spec.summary       = 'Appium Driver gem'
  spec.description   = 'Integration gem for run the Appium server and device emulator'
  spec.homepage      = 'https://github.com/DimaK888/appium_driver'

  spec.files       	 = `git ls-files -z`.split("\x0")
  spec.require_paths = ['lib']
  spec.licenses      = ['MIT']
end
