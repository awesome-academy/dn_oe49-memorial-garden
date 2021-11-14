FactoryBot.define do
  factory :user do
    name{Faker::Name.name_with_middle}
    email{Faker::Internet.email.downcase}
    password{"foobar"}
    password_confirmation{"foobar"}
  end
end
