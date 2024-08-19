require "test_helper"

class MedicationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get medications_index_url
    assert_response :success
  end

  test "should get show" do
    get medications_show_url
    assert_response :success
  end

  test "should get new" do
    get medications_new_url
    assert_response :success
  end

  test "should get edit" do
    get medications_edit_url
    assert_response :success
  end

  test "should get create" do
    get medications_create_url
    assert_response :success
  end

  test "should get update" do
    get medications_update_url
    assert_response :success
  end

  test "should get destroy" do
    get medications_destroy_url
    assert_response :success
  end
end
