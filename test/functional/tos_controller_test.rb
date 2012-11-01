require 'test_helper'

class TosControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
