require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'artist' => 'Zaz', 'album' => 'Zaz'}) 
    assert_response :success
  end
end
