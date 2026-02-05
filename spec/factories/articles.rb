FactoryBot.define do
  factory :article do
    content { Faker::Lorem.characters(number: 10) }
  end

  after(:build) do |article|
    article.images.attach(io: File.open('app/assets/images/form-top.png'), filename: 'form-top.png')
  end
end
