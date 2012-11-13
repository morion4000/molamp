require 'test_helper'

class ArtistsControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'id' => 'Zaz'}) 
    assert_response :success
  end
end
