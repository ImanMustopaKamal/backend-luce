# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
clients = Client.create([
  { name: 'Jon Snow', email: 'jon@snow.com', phone: '+6512321232' },
  { name: 'Arya Stark', email: 'arya@stark.com', phone: '+6512321233' },
  { name: 'Sansa Stark', email: 'sansa@stark.com', phone: '+6512321234' },
  { name: 'Robb Stark', email: 'rob@stark.com', phone: '+6512321235' },
  { name: 'Robert Baratheon', email: 'robert@baratheon.com', phone: '+6512321236' },
  { name: 'Danny Targaryen', email: 'danny@targaryen.com', phone: '+6512321237' }
])