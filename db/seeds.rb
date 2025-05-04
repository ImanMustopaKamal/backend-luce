# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
clients = Client.create([
  { name: 'Client 1', email: 'jon@snow.com', phone: '+6512321232' },
  { name: 'Client 2', email: 'arya@stark.com', phone: '+6512321233' },
  { name: 'Client 3', email: 'sansa@stark.com', phone: '+6512321234' },
  { name: 'Client 4', email: 'rob@stark.com', phone: '+6512321235' },
  { name: 'Client 5', email: 'robert@baratheon.com', phone: '+6512321236' },
  { name: 'Client 6', email: 'danny@targaryen.com', phone: '+6512321237' }
])