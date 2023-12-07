FactoryBot.define do
  factory :market_vendor do
    market_id { Faker::Number.number(digits: 7) }
    vendor_id { Faker::Number.number(digits: 7) }
  end
end
