require "test_helper"

class TransaksiControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get transaksi_index_url
    assert_response :success
  end

  test "should get show" do
    get transaksi_show_url
    assert_response :success
  end

  test "should get new" do
    get transaksi_new_url
    assert_response :success
  end

  test "should get edit" do
    get transaksi_edit_url
    assert_response :success
  end

  test "should get create" do
    get transaksi_create_url
    assert_response :success
  end

  test "should get update" do
    get transaksi_update_url
    assert_response :success
  end

  test "should get destroy" do
    get transaksi_destroy_url
    assert_response :success
  end
end
