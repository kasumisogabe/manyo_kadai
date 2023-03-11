FactoryBot.define do
  factory :user do
    name { "一般ユーザ" }
    email { "ippan@gmail.com" }
    password { "12345678" }
    admin { "false" }
  end

  factory :second_user, class: User do
    name { "管理者ユーザ" }
    email { "kanrisya@gmail.com" }
    password { "87654321" }
    admin { "true" }
  end
end
