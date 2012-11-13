require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'id' => 'Zaz'}) 
    assert_response :success
  end
  
  test "should get error 404" do
    get(:show, {'id' => 'Zazzzzzzzzzz'}) 
    assert_response :missing
    assert_template "error_404"
  end
end
