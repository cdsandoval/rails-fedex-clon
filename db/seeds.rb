require "faker"
con = 1
5.times do
  Sender.create(
  store_name: Faker::Commerce.department,
  email: Faker::Internet.email,
  order_id: con,
  city: Faker::Address.city,        
  country: Faker::Address.country,
  )
  con += 1
end

5.times do
  User.create(
    username: Faker::Name.unique.name,       
    email: Faker::Internet.email,          
    password: "123456",
    authentication_token: Devise.friendly_token[0, 30],
    city: Faker::Address.city,        
    country: Faker::Address.country,
    address: Faker::Address.street_address,  
    role: "regular"       
  )
end
5.times do
  Shipment.create(
    tracking_id: Faker::Alphanumeric.alphanumeric(10),
    origin_address: Faker::Address.full_address, 
    destination_address: Faker::Address.full_address, 
    weight: Faker::Number.between(1, 10),
    reception_date: Faker::Date.forward(60),
    estimated_delivery_date: Faker::Date.forward(60),
    freight_value: Faker::Number.between(20 ,100),
    user_id: User.all.reduce([]){ |array, val| array << val.id }.sample,
    sender_id: Sender.all.reduce([]){ |array, val| array << val.id }.sample
  )
end
5.times do 
  ShipmentLocation.create(
    city: Faker::Address.city,
    country: Faker::Address.country,
    reception_date:Faker::Date.forward(20),
    shipment_id: Shipment.all.reduce([]){ |array, val| array << val.id }.sample,
  )
end

User.create(
  username: "Paul",       
  email: "yummta+regular@gmail.com",          
  password: "123456",
  authentication_token: Devise.friendly_token[0, 30],
  city: "Lima",     
  country: "Peru",
  address: "Miraflores",  
  role: "regular"       
)

User.create(
  username: "Paul",       
  email: "yummta+admin@gmail.com",          
  password: "123456",
  authentication_token: Devise.friendly_token[0, 30],
  city: "Lima",     
  country: "Peru",
  address: "Miraflores",  
  role: "admin"
)

User.create(
  username: "Paul",       
  email: "yummta+sales@gmail.com",          
  password: "123456",
  authentication_token: Devise.friendly_token[0, 30],
  city: "Lima",     
  country: "Peru",
  address: "Miraflores",  
  role: "sales"       
)
User.create(
  username: "Paul",       
  email: "yummta+deposit@gmail.com",          
  password: "123456",
  authentication_token: Devise.friendly_token[0, 30],
  city: "NY",     
  country: "US",
  address: "Madisson",  
  role: "deposit"       
)

sendermailer = Sender.create(
  store_name: "Tienda prueba mailer",
  email: "diegotc86@gmail.com",
  order_id: 1000,
  city: "Lima",        
  country: "Peru",
)

usermailer = User.create(
  username: "Diego",       
  email: "diegotc86@gmail.com",          
  password: "123456",
  city: "Lima",     
  country: "Peru",
  address: "Direccion",  
  role: "regular"       
)

Shipment.create(
  tracking_id: "mailer1234",
  origin_address: "Direccion origen", 
  destination_address: "Direccion destino", 
  weight: 100,
  reception_date: Faker::Date.forward(60),
  estimated_delivery_date: Faker::Date.forward(60),
  freight_value: 200,
  user_id: usermailer.id,
  sender_id: sendermailer.id
)
p "Seed complete"
