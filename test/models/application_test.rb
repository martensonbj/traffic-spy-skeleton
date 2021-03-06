require_relative '../test_helper'
require_relative '../simulation_environment/test_data.rb'

class ApplicationDetailsTest < ControllerTestSetup

  def setup
    td = TestData.new(2)
    td.generate
  end

  def test_app_returns_sorted_url_data
    app = Application.find_by(identifier: 'google')
    assert_equal "{#<Url id: 2, url: \"blog\">=>6, #<Url id: 1, url: \"images\">=>4, #<Url id: 3, url: \"store\">=>2}", app.sorted_urls_by_request.to_s
  end

  def test_app_returns_user_agent_breakdown_across_all_requests
    app = Application.find_by(identifier: 'google')
    assert_equal "Chrome 24.0.1309", app.uniq_user_agents[0][0]
    assert_equal 1, app.uniq_user_agents.count
  end

  def test_os_breakdown_accross_all_requests
    app = Application.find_by(identifier: 'google')
    assert_equal "Mac OS X 10.8.2", app.uniq_user_agents[0][1]
    assert_equal 1, app.uniq_user_agents.count
  end

  def test_screen_reso_breakdown_accross_all_requests
    app = Application.find_by(identifier: 'google')
    assert_equal 2, app.uniq_screen_resolutions.count
    # assert_equal "[[500, 20000], [123, 12000]]", app.uniq_screen_resolutions.to_s
  end

  def test_average_response_time
    app = Application.find_by(identifier: 'google')
    average_response_time = app.average_response_times
    assert_equal 'images', average_response_time[0][0][:url]
    assert_equal 5.0, average_response_time[1][1]
  end

  def test_event_returns_sorted_event_data
    app =  Application.find_by(identifier: 'google')
    assert_equal 4, app.sorted_events.count
  end

end
