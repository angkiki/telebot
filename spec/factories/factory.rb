require 'faker'

FactoryBot.define do
  factory :transaction do
    description { "Something something" }
    amount { Faker::Number.decimal(2) }
    category { Faker::Number.between(0, 3) }
    chat
  end

  factory :chat do
    chat_id { Faker::Number.number(6) }
    username  { Faker::Name.last_name }
    command { "/done" }

    factory :chat_with_transactions do
      # transactions_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
      transient do
        transactions_count { 5 }
      end

      # the after(:create) yields two values; the chat instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |chat, evaluator|
        create_list(:transaction, evaluator.transactions_count, chat: chat)
      end
    end
  end

end
