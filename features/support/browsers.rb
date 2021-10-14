# Original Source
# https://gist.github.com/bbonamin/4b01be9ed5dd1bdaf909462ff4fdca95
require 'capybara/rspec'
require 'selenium/webdriver'
require 'cucumber'


### Google Chrome

chrome_options = Selenium::WebDriver::Chrome::Options.new
chrome_options.add_preference(:download, prompt_for_download: false,
                                  default_directory: '/tmp/downloads')

chrome_options.add_preference(:browser, set_download_behavior: { behavior: 'allow' })

Capybara.register_driver :chrome do |app|
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)
end

Capybara.register_driver :headless_chrome do |app|
  chrome_options.add_argument('--headless')
  chrome_options.add_argument('--disable-gpu')
  chrome_options.add_argument('--window-size=1680,1050')

  driver = Capybara::Selenium::Driver.new(app, browser: :chrome, options: chrome_options)

  ### Allow file downloads in Google Chrome when headless!!!
  ### https://bugs.chromium.org/p/chromium/issues/detail?id=696481#c89
  bridge = driver.browser.send(:bridge)

  path = '/session/:session_id/chromium/send_command'
  path[':session_id'] = bridge.session_id

  bridge.http.call(:post, path, cmd: 'Page.setDownloadBehavior',
                                params: {
                                  behavior: 'allow',
                                  downloadPath: '/tmp/downloads'
                                })
  ###

  driver
end

#### Safari (macOS only.)


### Firefox
Capybara.register_driver :firefox do |app|
  Capybara::Selenium::Driver.new(app, browser: :firefox)
end

Capybara.register_driver :headless_firefox do |app|
  options = Selenium::WebDriver::Firefox::Options.new
  options.headless! # added on https://github.com/SeleniumHQ/selenium/pull/4762

  Capybara::Selenium::Driver.new app,
    browser: :firefox,
    options: options
end

Capybara.javascript_driver = ENV['GUI'] ? :chrome : :headless_chrome
Capybara.default_driver = :headless_chrome
