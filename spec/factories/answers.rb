FactoryBot.define do
  factory :answer do
    body { 'Answer' }
    correct { true }
    association :question
    association :user

    trait :invalid do  
      body { nil }
    end
  end
end
