require "test_helper"

class TutorPatientsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tutor_patients_show_url
    assert_response :success
  end
end
