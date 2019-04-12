require 'test_helper'

class ItemTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get item_types_index_url
    assert_response :success
  end

end
