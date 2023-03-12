# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
10.times do |n|
  email = Faker::Internet.email
  name = "name"
  password = "password"
  User.create!(name: name,
                email: email,
                password: password,
                )
end

users = User.all
users = users.map{|user|user.id}

10.times do |t|
  title = "title"
  content = "content"
  limit = "limit"
  status = "status"
  priority = "高"
  user_id = "users.sample"
  Task.create!(title: title,
                content: content,
                limit: limit,
                status: status,
                priority: priority,
                user_id: users.sample,
                )
end

10.times do |l|
  name = Faker::Games::Pokemon.name
  Label.create!(name: name,
                )
end