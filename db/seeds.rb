# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


app = Rapns::Apns::App.new
app.name = "filmlovr_app"
app.certificate = File.read("lib/ios/sandbox.pem")
app.environment = "sandbox" # APNs environment.
app.password = "f1lml0vr"
app.connections = 1
app.save!