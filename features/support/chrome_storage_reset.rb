# frozen_string_literal: true

# Chrome 158 rejects the wildcard origin that Capybara (through 3.40.0) passes
# to Storage.clearDataForOrigin when it resets the browser between scenarios:
#
#   invalid argument: * is not a valid URL (Selenium::WebDriver::Error::InvalidArgumentError)
#
# That raises in the After hook and fails every scenario, even when all of its
# steps passed. When Chrome refuses the wildcard, clear the same state another
# way: all cookies via Network.clearBrowserCookies, and storage for the origin
# the scenario was on. Remove this once Capybara ships a fix.
module ChromeStorageReset
  def reset!
    @origin_to_clear = current_origin if @browser
    super
  end

  private
  def execute_cdp(cmd, params = {})
    super
  rescue Selenium::WebDriver::Error::InvalidArgumentError
    raise unless cmd == "Storage.clearDataForOrigin" && params[:origin] == "*"

    super("Network.clearBrowserCookies")
    super(cmd, params.merge(origin: @origin_to_clear)) if @origin_to_clear
  end

  def current_origin
    uri = URI.parse(current_url.to_s)
    uri.origin if uri.is_a?(URI::HTTP)
  rescue URI::InvalidURIError
    nil
  end
end

Capybara::Selenium::Driver::ChromeDriver.prepend(ChromeStorageReset)
