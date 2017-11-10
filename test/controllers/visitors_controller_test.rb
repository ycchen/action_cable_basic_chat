require 'test_helper'

class VisitorsControllerTest < ActionDispatch::IntegrationTest
  test "should get chat" do
    get visitors_chat_url
    assert_response :success
  end

end
