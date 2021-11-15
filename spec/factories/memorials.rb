FactoryBot.define do
  factory :memorial do
    name{Faker::Name.name_with_middle}
    user{create(:user)}
    relationship{Faker::Relationship.familial}
  end
end
