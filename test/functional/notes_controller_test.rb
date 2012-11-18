require 'test_helper'

class NotesControllerTest < ActionController::TestCase
  setup do
    @note = notes(:general_000)
    @others_note = notes(:other_000)
    @user = users(:general)
    activate_authlogic
  end


  #################### Index
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
  #################### Index



  #################### Show
  test "should showr" do
    assert UserSession.create(@user)
    get :show, id: @note.id.to_s
    assert_response :success
    json_obj = JSON.parse(@response.body)
    assert_note_response(@note, json_obj)
  end

  test "should NOT show note by not owner" do
    assert UserSession.create(@user)
    get :show, id: @others_note.id.to_s
    assert_response 403
    json_obj = JSON.parse(@response.body)
    assert_equal I18n.t('error.unauthorized_access'), json_obj['error_message']
  end
  #################### Show



  #################### Create
  test "should create note" do
    assert UserSession.create(@user)
    assert_difference('Note.count') do
      assert_difference('@user.notes.count') do
        post :create, note: {title: "sample-title", body: "sample-body"}
      end
    end
    assert_response :success
    json_obj = JSON.parse(@response.body)
    assert_equal "sample-title", json_obj["title"]
    assert_equal "sample-body",  json_obj["body"]
  end

  test "should NOT create note bacause title is too long" do
    assert UserSession.create(@user)
    assert_no_difference('Note.count') do
      assert_no_difference('@user.notes.count') do
        post :create, note: {title: 'a'*256, body: "sample-body"}
      end
    end
    assert_response :bad_request
    json_obj = JSON.parse(@response.body)
    err_msg = I18n.t('errors.messages.record_invalid', errors: nil) +
              I18n.t('activerecord.attributes.note.title') +
              I18n.t('errors.messages.too_long', count: 255)
    assert_equal err_msg, json_obj['error_message']
  end
  #################### Create



  #################### Update
  test "should update note" do
    assert UserSession.create(@user)
    put :update, id: @note.id.to_s, note: { body: "sample-body" }
    assert_equal "sample-body", @note.reload.body
    json_obj = JSON.parse(@response.body)
    assert_note_response(@note, json_obj)
  end

  test "should NOT update note because title is too long" do
    assert UserSession.create(@user)
    before_title = @note.title
    put :update, id: @note.id.to_s, note: { title: 'a'*256 }

    assert_response :bad_request
    json_obj = JSON.parse(@response.body)
    err_msg = I18n.t('errors.messages.record_invalid', errors: nil) +
              I18n.t('activerecord.attributes.note.title') +
              I18n.t('errors.messages.too_long', count: 255)
    assert_equal err_msg, json_obj['error_message']
    assert_equal before_title, @note.reload.title
  end

  test "should NOT update note by not owner" do
    assert UserSession.create(@user)
    before_title = @others_note.title
    put :update, id: @others_note.id.to_s, note: { title: 'a'*256 }
    assert_response :forbidden
    json_obj = JSON.parse(@response.body)
    assert_equal I18n.t('error.unauthorized_access'), json_obj['error_message']
    assert_equal before_title, @others_note.reload.title
  end
  #################### Update


  #################### Test Methods
  def assert_note_response(note, hash)
    hash.symbolize_keys!
    [:id, :title, :body, :created_at, :updated_at].each do |col|
      if col == :created_at || col == :updated_at
        assert_equal note.__send__(col).to_s, Time.zone.parse(hash[col]).to_s,
                     "fail on #{col}"
      else
        assert_equal note.__send__(col), hash[col], "fail on #{col}"
      end
    end
  end
  #################### Test Methods
end
