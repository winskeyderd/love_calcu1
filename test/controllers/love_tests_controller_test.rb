require "test_helper"

class LoveTestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get love_tests_index_url
    assert_response :success
  end

  test "should get new" do
    get love_tests_new_url
    assert_response :success
  end

  test "should get create" do
    get love_tests_create_url
    assert_response :success
  end
end
