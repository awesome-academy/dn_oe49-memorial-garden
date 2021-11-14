FactoryBot.define do
  factory :contribution do
    user{create :user}
    memorial{create :memorial}

    trait :for_tribute do
      contribution_type{:tribute}
      association :tribute, factory: :tribute, strategy: :build
    end

    factory :contribution_with_tribute, traits: [:for_tribute]
  end
end
