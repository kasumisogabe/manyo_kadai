FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    limit {'2023-03-08'}
  end
end