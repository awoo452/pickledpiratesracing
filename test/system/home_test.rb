require "application_system_test_case"

class HomeTest < ApplicationSystemTestCase
  test "visits home" do
    visit root_path

    assert_text "Racing since"
  end
end
