require 'test_helper'

class PdfsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get pdfs_index_url
    assert_response :success
  end

end
