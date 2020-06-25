require 'capybara'
require 'capybara/cucumber'
require 'rspec'
require 'selenium-webdriver'
require 'faker'
require 'rest-client'
require 'capybara-screenshot/cucumber'
require 'json'
require 'net/ssh'
require 'net/sftp'
require 'nokogiri'
require 'pry'
require 'show_me_the_cookies'

#default driver setup
case ENV['BROWSER']

	when 'Firefox'
		Capybara.register_driver :selenium do |app|
			Capybara::Selenium::Driver.new(app, {:browser => :firefox})
		end

	when 'IE'
		Capybara.register_driver :selenium do |app|
			Capybara::Selenium::Driver.new(app, {:browser => :ie})
		end

	when 'headless-chrome'
		puts 'headless chrome'
		Capybara.register_driver :selenium do |app|
			capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
				chromeOptions: { args: %w(headless disable-gpu no-sandbox window-size=1920,1080) }
			)
			Capybara::Selenium::Driver.new app, browser: :chrome, desired_capabilities: capabilities
		end


	else 'Chrome'
	Capybara.register_driver :selenium do |app|
		caps = Selenium::WebDriver::Remote::Capabilities.chrome('chromeOptions' => {'args' => ['--start-maximized']})
		Capybara::Selenium::Driver.new(app, {:browser => :chrome, :desired_capabilities => caps})
	end

end

Capybara.default_driver = :selenium
#Capybara.page.driver.browser.manage.window.maximize
Selenium::WebDriver.logger.level = 3

Capybara::Screenshot.prune_strategy = { keep: 5 }
Capybara.save_path = 'reports/screenshots'
Capybara.default_max_wait_time = 15
Capybara.reset_sessions!

#Screenshot will be taken manually before closing the browser
Capybara::Screenshot.autosave_on_failure = false

#global variables,if any can be initialised here

# After Scenario
After do |scenario|

	if scenario.failed?

		# Copied from capybara-screenshot/cucumber.rb to ensure screenshot is taken before closing browser
		Capybara.using_session(Capybara::Screenshot.final_session_name) do
			filename_prefix = Capybara::Screenshot.filename_prefix_for(:cucumber, scenario)

			saver = Capybara::Screenshot.new_saver(Capybara, Capybara.page, true, filename_prefix)
			saver.save
			saver.output_screenshot_path

			# Trying to embed the screenshot into our output."
			if File.exist?(saver.screenshot_path)
				require 'base64'
				#encode the image into it's base64 representation
				image = open(saver.screenshot_path, 'rb') {|io|io.read}
				saver.display_image
				#this will embed the image in the HTML report, embed() is defined in cucumber
				encoded_img = Base64.encode64(image)
				embed(encoded_img, 'image/png;base64', 'Screenshot of the error')
			end
		end
	end
end
