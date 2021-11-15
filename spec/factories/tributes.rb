FactoryBot.define do
  factory :tribute do
    eulogy{Faker::Quotes::Shakespeare.as_you_like_it_quote}
  end
end
