require 'rails_helper'

RSpec.describe 'a user adds a new menu item' do

  # ACCEPTANCE CRITERIA
  # I can add menu item
  # I must provide a name
  # I must provide a description
  # I must provide a price
  # I can see my new menu item

  context "with_valid_attributes" do
    it 'sees applicable errors' do
      visit new_menu_item_path

      click_on "Create Menu item"

      within ".input.menu_item_name" do
        expect(page).to have_content  "can't be blank"
      end

      within ".input.menu_item_description" do
        expect(page).to have_content "can't be blank"
      end

      within ".input.menu_item_price_in_cents" do
        expect(page).to have_content "can't be blank"
      end

      within ".input.menu_item_category" do
        expect(page).to have_content "can't be blank"
      end
    end

    it 'creates a new menu item' do
      name = 'pizza'
      description = 'a delicious cheesy surprise'
      cost = 1001
      category = 'Seafood'

      visit new_menu_item_path
      fill_in "Name", with: name
      fill_in "Description", with: description
      fill_in "Price in cents", with: cost
      select category, from: "Category"
      click_on "Create Menu item"

      expect(page).to have_content name
      expect(page).to have_content description
      expect(page).to have_content "$10.01"
      expect(page).to have_content category
    end
  end

  context "with invaid attributes" do
    it 'sees applicable errors' do
      visit new_menu_item_path

      click_on "Create Menu item"

      expect(page).to have_content "Name can't be blank"
      expect(page).to have_content "Description can't be blank"
      expect(page).to have_content "Price in cents can't be blank"
    end
  end
end
