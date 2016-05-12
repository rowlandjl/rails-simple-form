# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    sequence(:body) { "Super awesome#{n} comment" }
    association :menu_item
  end
end
