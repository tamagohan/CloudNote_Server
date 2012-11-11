require 'test_helper'

class UserTest < ActiveSupport::TestCase
  #################### Association
  test "should get notes" do
    user = users(:general)
    expected_notes = [notes(:general_000), notes(:general_001)]
    assert_equal expected_notes, user.notes
  end
  #################### Association
end
