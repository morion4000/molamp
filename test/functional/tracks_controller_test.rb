require 'test_helper'

class TracksControllerTest < ActionController::TestCase
  test "should get show" do
    get(:show, {'artist' => 'Zaz', 'track' => 'Je veux'}) 
    assert_response :success
  end
  
  test "should get error 404" do
   get(:show, {'artist' => 'Zaz', 'track' => 'Je veuxxxxxxxx'}) 
    assert_response :missing
    assert_template "error_404"
  end
end
