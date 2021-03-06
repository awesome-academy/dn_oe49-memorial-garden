user = User.create!(name: "Thanh Le",
             gender: 1,
             email: "thanh.lq011299@gmail.com",
             password: "123456",
             password_confirmation: "123456",
             admin: 1)
5.times do |n|
  memorial_name = Faker::Name.name
  relationship = Faker::Relationship.familial
  biography = Faker::TvShows::GameOfThrones.quote
  memorial = user.memorials.create(name: memorial_name,
    relationship: relationship, biography: biography)
  birth_date = Faker::Date.birthday(min_age: 18, max_age: 90)
  death_date = Faker::Date.between(from: birth_date.next_year(18),
                                   to: Date.today)
  birth_place = Faker::Address.country
  death_place  = Faker::Address.country
  memorial.placetimes.create(date: birth_date,
                             location: birth_place, is_born: 1)
  memorial.placetimes.create(date: death_date,
                             location: death_place, is_born: 0)
  memorial.contributions.create(user_id: user.id, relationship: relationship, contribution_type: 0, tribute_attributes: {eulogy: 'goodbye'})
end
5.times do |n|
  user_name = Faker::Name.name
  email = "user#{n}@gmail.com"
  password = "123456"
  user = User.create!(name: user_name,
               email: email,
               password: password,
               password_confirmation: password)
  5.times do |n|
    memorial_name = Faker::Name.name
    relationship = Faker::Relationship.familial
    biography = Faker::TvShows::GameOfThrones.quote
    memorial = user.memorials.create(name: memorial_name, biography: biography,
                                     relationship: relationship)
    birth_date = Faker::Date.birthday(min_age: 18, max_age: 90)
    death_date = Faker::Date.between(from: birth_date.next_year(18),
                                     to: Date.today)
    birth_place = Faker::Address.country
    death_place  = Faker::Address.country
    memorial.placetimes.create(date: birth_date,
                               location: birth_place, is_born: 1)
    memorial.placetimes.create(date: death_date,
                               location: death_place, is_born: 0)
    # memorial.avatar.attach(io: File.open(Rails.root.join('../Pictures/yen.jpg')),
    #               filename: 'yen.jpg')
  end
end

  # p name
  # convention_name = name.split(" ")
  # p convention_name
flower_paths = Dir["../Pictures/flower/*"]
flower_paths.each do |image_path|
  image_name = image_path[(/[\w-]+\.jpg/)]
  name = image_path[(/[\w-]+\.jpg/)].gsub('.jpg', '')
                                    .split(/(?=[A-Z])/).join('_').downcase
  flower = FlowerDetail.create(name: name)
  flower.image.attach(io: File.open(Rails.root.join("#{image_path}")),
                  filename: image_path)
end

users = User.all
memorials = Memorial.all
memorials.each do |memorial|
  memorial.share users.excluding(memorial.user)
  users.each do |user|
    eulogy = Faker::Quotes::Shakespeare.as_you_like_it_quote
    memorial.contributions.create(user_id: user.id, contribution_type: :tribute, tribute_attributes: {eulogy: eulogy})
    memorial.contributions.create(user_id: user.id,
      contribution_type: :flower, flower_attributes: {flower_detail_id:
        (1..FlowerDetail.all.count).to_a.sample, message: eulogy})
  end
end
