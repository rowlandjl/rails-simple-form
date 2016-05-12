require 'rails_helper'

RSpec.describe 'a user views all the items' do

  # ACCEPTANCE CRITERIA
  # I see all the menu items on the index page

  let!(:menu1) { FactoryGirl.create(:menu_item, name: 'pizza') }
  let!(:menu2) { FactoryGirl.create(:menu_item, name: 'pasta') }

  it 'sees all the menu items listed on the index page' do
    visit menu_items_path

    expect(page).to have_content 'HERE IS THE MENU ITEM INDEX PAGE'
    expect(page).to have_content 'pizza'
    expect(page).to have_content 'pasta'
  end
end
