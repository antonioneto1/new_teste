require "test_helper"

class IndexControllerTest < ActionDispatch::IntegrationTest
  test "should get import" do
    get index_import_url
    assert_response :success
  end

  test "should get consulta" do
    get index_consulta_url
    assert_response :success
  end
end
