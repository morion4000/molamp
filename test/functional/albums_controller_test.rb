require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'artist' => 'Zaz', 'album' => 'Zaz'}) 
    assert_response :success
  end
  
  test "should get error 404" do
    get(:show, {'artist' => 'Zaz', 'album' => 'Zazzzzzzz'}) 
    assert_response :missing
    assert_template "error_404"
  end
end
