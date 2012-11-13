require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get index generic" do
    get(:index, {'q' => 'Zaz', 'w' => 'generic'}) 
    assert_response :success
  end
  
  test "should get index home" do
    get(:index, {'q' => 'Zaz', 'w' => 'home'}) 
    assert_redirected_to '/artists/Zaz'
  end
end
