require 'spec_helper'

describe 'a user comments on a menu item' do

  # ACCEPTANCE CRITERIA
  # I can comment on a menu item from the menu item show page
  # I cannot create blank comments

  context "when given valid attributes" do
    it 'creates a comment' do
      menu_item = FactoryGirl.create(:menu_item)

      visit menu_item_path(menu_item)
      fill_in "Comment", with: 'Great tasting yummy meal'
      click_on "Create Comment"

      expect(page).to have_content "Your comment was created successfully."
    end
  end

  context "when given invalid attributes" do
    it 'does not create a comment' do
      menu_item = FactoryGirl.create(:menu_item)

      visit menu_item_path(menu_item)
      fill_in "Comment", with: ''
      click_on "Create Comment"

      expect(page).to have_content "There was an issue with your comment. Please try again."
    end
  end
end
