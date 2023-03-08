FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    limit { '2023-03-10' }
    status { '着手中' }
  end
end