require 'test_helper'

class NoteTest < ActiveSupport::TestCase
  #################### Association
  test "should get owner" do
    note = notes(:general_000)
    user = users(:general)
    assert_equal user, note.user
  end
  #################### Association
end
