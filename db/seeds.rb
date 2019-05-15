# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do
    Item.create(
        title: Faker::Coffee.blend_name,
        price: 333,
        date: Faker::Date.between(2.days.ago, Date.today),
        image_url: '',
        item_type_id: 29,
        user_id: 3
    )
end