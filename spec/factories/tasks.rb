FactoryBot.define do
  factory :task do
    title { 'test_title' }
    content { 'test_content' }
    limit { '2023-03-11' }
    status { '着手中' }
  end

  factory :second_task, class: Task do
    title { 'テスト2' }
    content { 'テストの内容2' }
    limit {'2023-03-10'}
    status {'未着手'}
  end
end