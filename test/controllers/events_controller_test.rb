require "test_helper"

class EventsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "should get index" do
    sign_in users(:one)
    get events_url
    assert_response :success
  end

  test "redirects unauthenticated users" do
    get events_url
    assert_response :redirect
  end
end
