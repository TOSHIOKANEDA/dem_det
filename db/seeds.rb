# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Carrier.create!(
  name: "SITC", 
  range: "first",
  dem_det: "dem",
  price: 3000,
  container_type: 1,
  port: "ALL",
  from: 1,
  to: 7,
  free: 7,
  calc: 0
)
Carrier.create!(
  name: "SITC", 
  range: "second",
  dem_det: "dem",
  price: 6000,
  container_type: 1,
  port: "ALL",
  from: 8,
  to: 15,
  free: 7,
  calc: 0
)
Carrier.create!(
  name: "SITC", 
  range: "third",
  dem_det: "dem",
  price: 9000,
  container_type: 1,
  port: "ALL",
  from: 15,
  to: 20,
  free: 7,
  calc: 0
)
Carrier.create!(
  name: "SITC", 
  range: "fourth",
  dem_det: "dem",
  price: 12000,
  container_type: 1,
  port: "ALL",
  from: 21,
  to: 999999,
  free: 7,
  calc: 0
)

Carrier.create!(
  name: "ONE", 
  range: "first",
  dem_det: "dem",
  price: 6000,
  container_type: 2,
  port: "ALL",
  from: 1,
  to: 4,
  free: 7,
  calc: 1
)
Carrier.create!(
  name: "ONE", 
  range: "second",
  dem_det: "dem",
  price: 18000,
  container_type: 2,
  port: "ALL",
  from: 5,
  to: 9,
  free: 7,
  calc: 1
)
Carrier.create!(
  name: "ONE", 
  range: "third",
  dem_det: "dem",
  price: 30000,
  container_type: 2,
  port: "ALL",
  from: 10,
  to: 99999999,
  free: 7,
  calc: 1
)
