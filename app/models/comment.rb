class Comment < ActiveRecord::Base
  belongs_to :menu_item,
    inverse_of: :comments

  validates :menu_item, presence: true
  validates :body, presence: true
  validates :body, length: { minimum: 16 }
end
