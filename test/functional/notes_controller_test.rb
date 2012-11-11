require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    @note = notes(:general_000)
    @others_note = notes(:other_000)
    @user = users(:general)
    activate_authlogic
  end

  test "should get index" do
    assert UserSession.create(@user)
    get :index
    assert_response :success
    json_obj = JSON.parse(@response.body)
    expected_notes = @user.notes
    json_obj.each do |item|
      note = Note.find(item["id"])
      assert_note_response(note, item)
    end
  end

  test "should create note" do
    assert_difference('Note.count') do
      post :create, note: @note.attributes
    end

    assert_redirected_to note_path(assigns(:note))
  end

  test "should NOT show note by not owner" do
    assert UserSession.create(@user)
    get :show, id: @others_note.id.to_s
    p @response.status
    assert_response 403
    json_obj = JSON.parse(@response.body)
    p json_obj
    assert_note_response(@note, json_obj)
  end

  test "should update note" do
    put :update, id: @note.to_param, note: @note.attributes
    assert_redirected_to note_path(assigns(:note))
  end

  test "should destroy note" do
    assert_difference('Note.count', -1) do
      delete :destroy, id: @note.to_param
    end

    assert_redirected_to notes_path
  end

  def assert_note_response(note, hash)
    hash.symbolize_keys!
    Note.column_names.each do |col|
      assert_equal note.__send__(col.to_sym), hash[col.to_sym]
    end
  end
end
