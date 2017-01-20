User.create!(name: "Admin",
  email: "admin@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  role: 1,
  avatar: "http://wpidiots.com/html/ravan/standard/img/avatar3.png")
User.create!(name: "Test",
  email: "test@gmail.com",
  password: "123456",
  password_confirmation: "123456",
  avatar: "http://wpidiots.com/html/ravan/standard/img/avatar3.png")

99.times do |n|
  name = Faker::Name.name
  email = "trainee-#{n+1}@gmail.com"
  password = "123456"
  password_confirmation = "123456"
  avatar = "http://wpidiots.com/html/ravan/standard/img/avatar3.png"
  User.create!(name: name, email: email, password: password,
    password_confirmation: password, role: 0, avatar: avatar)
end

users = User.all
user  = users.first
following = users[2..15]
followers = users[3..13]
following.each { |followed| user.follow(followed) }
followers.each { |follower| follower.follow(user) }
