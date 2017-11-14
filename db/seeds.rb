# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
(0..100).each do |p|
  Job.create(title: Faker::Commerce.product_name, job_description: Faker::Company.catch_phrase, user_id: 23, work_location: "Central Luzon")
  puts "Created #{p}"
end
