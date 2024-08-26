require "test_helper"

class TakesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get takes_index_url
    assert_response :success
  end
end
