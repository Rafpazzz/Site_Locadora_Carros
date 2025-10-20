require "application_system_test_case"

class LocatariosTest < ApplicationSystemTestCase
  setup do
    @locatario = locatarios(:one)
  end

  test "visiting the index" do
    visit locatarios_url
    assert_selector "h1", text: "Locatarios"
  end

  test "should create locatario" do
    visit locatarios_url
    click_on "New locatario"

    fill_in "Cpf", with: @locatario.cpf
    fill_in "Nome", with: @locatario.nome
    click_on "Create Locatario"

    assert_text "Locatario was successfully created"
    click_on "Back"
  end

  test "should update Locatario" do
    visit locatario_url(@locatario)
    click_on "Edit this locatario", match: :first

    fill_in "Cpf", with: @locatario.cpf
    fill_in "Nome", with: @locatario.nome
    click_on "Update Locatario"

    assert_text "Locatario was successfully updated"
    click_on "Back"
  end

  test "should destroy Locatario" do
    visit locatario_url(@locatario)
    click_on "Destroy this locatario", match: :first

    assert_text "Locatario was successfully destroyed"
  end
end
