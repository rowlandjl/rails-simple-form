class MenuItem < ActiveRecord::Base
  CATEGORIES = %w{Seafood Pasta Vegetarian}

  has_many :comments,
    inverse_of: :menu_item

  validates :name, presence: true
  validates :description, presence: true
  validates :price_in_cents, presence: true
  validates :category, presence: true

  validates :category, inclusion: { in: CATEGORIES }

  def price_in_dollars
    (price_in_cents.to_f / 100).round(2)
  end
end
