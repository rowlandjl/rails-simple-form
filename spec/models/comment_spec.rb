require 'rails_helper'

RSpec.describe Comment do
  it { should_not have_valid(:body).when(nil, "", "short") }
  it { should have_valid(:body).when("abcdefghijklmnop") }

  it { should_not have_valid(:menu_item).when(nil) }
  it { should have_valid(:menu_item).when(MenuItem.new) }

  it { should belong_to :menu_item }
end
