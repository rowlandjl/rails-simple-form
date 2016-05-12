require 'rails_helper'

RSpec.describe 'a user view a menu item' do

  # ACCEPTANCE CRITERIA
  # I see a menu item

  let(:menu_item) { FactoryGirl.create(:menu_item) }

  it 'views the info of a menu item' do
    visit menu_item_path(menu_item)

    expect(page).to have_content menu_item.name
    expect(page).to have_content menu_item.description
  end
end
