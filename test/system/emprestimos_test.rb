require "application_system_test_case"

class EmprestimosTest < ApplicationSystemTestCase
  setup do
    @emprestimo = emprestimos(:one)
  end

  test "visiting the index" do
    visit emprestimos_url
    assert_selector "h1", text: "Emprestimos"
  end

  test "should create emprestimo" do
    visit emprestimos_url
    click_on "New emprestimo"

    fill_in "Status", with: @emprestimo.status
    click_on "Create Emprestimo"

    assert_text "Emprestimo was successfully created"
    click_on "Back"
  end

  test "should update Emprestimo" do
    visit emprestimo_url(@emprestimo)
    click_on "Edit this emprestimo", match: :first

    fill_in "Status", with: @emprestimo.status
    click_on "Update Emprestimo"

    assert_text "Emprestimo was successfully updated"
    click_on "Back"
  end

  test "should destroy Emprestimo" do
    visit emprestimo_url(@emprestimo)
    click_on "Destroy this emprestimo", match: :first

    assert_text "Emprestimo was successfully destroyed"
  end
end
