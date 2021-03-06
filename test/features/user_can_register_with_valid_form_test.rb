require_relative '../test_helper'

class UserCanRegisterWithValidFormTest < FeatureTest

  def setup
    post '/sources', "identifier=ultratest&rootUrl=http://ultratest.com"

    payload_data = {"url": "http://ultratest.com/tester",
                    "requestedAt": "2015-11-23 11:23:15 -0700",
                    "respondedIn": 100,
                    "referredBy": "http://google.com",
                    "requestType": "POST",
                    "parameters": [],
                    "eventName": "socialLogin",
                    "userAgent": "Mozilla/5.0 (Macintosh%3B Intel Mac OS X 10_8_2) AppleWebKit/537.17 (KHTML, like Gecko) Chrome/24.0.1309.0 Safari/537.17",
                    "resolutionWidth": 1920,
                    "resolutionHeight": 1080,
                    "ip": "126.127.128"}.to_json

                    post "/sources/ultratest/data", {payload: payload_data}
  end

  def test_user_can_register_with_valid_request
      visit "/register"
      assert_equal "/register", current_path

      fill_in('identifier', :with => 'ultratest')
      fill_in('rootUrl', :with => 'http://ultratest.com')
      click_button('Submit')

      assert_equal "/", current_path
  end

end
