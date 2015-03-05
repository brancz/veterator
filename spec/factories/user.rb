FactoryGirl.define do
  factory :user do |u|
    u.sequence(:email) { |n| "test#{n}@example.org" }
    u.password 'Passw0rd!'
    u.password_confirmation 'Passw0rd!'
  end

  factory :confirmed_user, parent: :user do
    after(:create) { |u| u.confirm! }
  end

  factory :sensor do |s|
    title 'Test Title'
    description 'Test Description'
  end
end

