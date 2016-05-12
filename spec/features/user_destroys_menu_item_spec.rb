require 'rails_helper'

RSpec.describe 'a user destroys a menu item' do

  # ACCEPTANCE CRITERIA
  # I can destroy menu item
  # I can confirm that my menu item is no longer persisted

  it 'destroys a menu item' do
    menu_item = FactoryGirl.create(:menu_item)

    visit menu_items_path
    click_on "Destroy #{menu_item.name}"

    expect(page).not_to have_content menu_item.description
    expect(page).to have_content 'Menu item was successfully destroyed'
  end
end
