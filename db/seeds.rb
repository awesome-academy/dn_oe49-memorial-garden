user = User.create!(name: "Thanh Le",
             gender: 1,
             email: "thanh.lq011299@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             role: 1)
10.times do |n|
  memorial_name = Faker::Name.name
  relationship = Faker::Relationship.familial
  memorial = user.memorials.create(name: memorial_name,
                                       relationship: relationship)
  birth_date = Faker::Date.birthday(min_age: 18, max_age: 65)
  death_date = Faker::Date.between(from: birth_date, to: Date.today)
  birth_place = Faker::Address.country
  death_place  = Faker::Address.country
  memorial.placetimes.create(date: birth_date,
                             location: birth_place, is_born: 1)
  memorial.placetimes.create(date: death_date,
                             location: death_place, is_born: 0)
end
10.times do |n|
  user_name = Faker::Name.name
  email = "user#{n}@gmail.com"
  password = "123456"
  user = User.create!(name: user_name,
               email: email,
               password: password,
               password_confirmation: password)
  10.times do |n|
    memorial_name = Faker::Name.name
    relationship = Faker::Relationship.familial
    memorial = user.memorials.create(name: memorial_name,
                                     relationship: relationship)
    birth_date = Faker::Date.birthday(min_age: 18, max_age: 65)
    death_date = Faker::Date.between(from: birth_date, to: Date.today)
    birth_place = Faker::Address.country
    death_place  = Faker::Address.country
    memorial.placetimes.create(date: birth_date,
                               location: birth_place, is_born: 1)
    memorial.placetimes.create(date: death_date,
                               location: death_place, is_born: 0)
  end
end
