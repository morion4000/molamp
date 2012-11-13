require 'test_helper'

class TracksControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'artist' => 'Zaz', 'track' => 'Je veux'}) 
    assert_response :success
  end
end
