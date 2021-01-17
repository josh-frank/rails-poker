require "test_helper"

class HandsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get hands_show_url
    assert_response :success
  end
end
