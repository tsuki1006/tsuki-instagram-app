FactoryBot.define do
  factory :article do
    content { Faker::Lorem.characters(number: 20) }

    trait :with_image do
      after(:build) do |article|
        article.images.attach(io: File.open('app/assets/images/test.png'), filename: 'test.png')
      end
    end
  end
end
