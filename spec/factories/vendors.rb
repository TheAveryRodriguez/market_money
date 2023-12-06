FactoryBot.define do
  factory :vendor do
    name { Faker::FunnyName.name }
    description { Faker::Lorem.paragraph }
    contact_name { Faker::FunnyName.name }
    contact_phone { Faker::PhoneNumber.phone_number }
    credit_accepted { Faker::Boolean.boolean }
  end
end
