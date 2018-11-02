require_relative('./models/customer')
require_relative('./models/ticket')
require_relative('./models/film')
require_relative('./models/screening')

require('pry-byebug')

Customer.delete_all
Film.delete_all
Ticket.delete_all
Screening.delete_all

customer1 = Customer.new({'name' => 'Frank','wallet' => 50_000.50})
customer2 = Customer.new({'name' => 'dEE','wallet' => 20.50})
customer3 = Customer.new({'name' => 'ChArLie','wallet' => 5.25})
customer4 = Customer.new({'name' => 'dENnis','wallet' => 400})
customer5 = Customer.new({'name' => 'mac','wallet' => 40.50})
customer6 = Customer.new({'name' => 'frank','wallet' => 1})

customer1.save
customer2.save
customer3.save
customer4.save
customer5.save
customer6.save

film1 = Film.new({'title' => 'Lethal Weapon 6', 'price' => 4.25})
film2 = Film.new({'title' => 'Avatar 2: The Avataring', 'price' => 85.50})
film3 = Film.new({'title' => 'Rocky VII: Adrians Revenge', 'price' => 5.50})
film4 = Film.new({'title' => 'Kill Jar-Jar: A Star Wars Story', 'price' => 10.50})
film5 = Film.new({'title' => 'The Contrabulous Fabtraption of Professor Horatio Hufnagel', 'price' => 1.05})
film6 = Film.new({'title' => 'The Room', 'price' => 5.55})

film1.save
film2.save
film3.save
film4.save
film5.save
film6.save

screening1 = Screening.new({'film_id' => film1.id, 'remaining_tickets' => 200, 'start_time' => '14:30'})
screening2 = Screening.new({'film_id' => film1.id, 'remaining_tickets' => 200, 'start_time' => '18:30'})
screening3 = Screening.new({'film_id' => film2.id, 'remaining_tickets' => 50, 'start_time' => '17:30'})
screening4 = Screening.new({'film_id' => film3.id, 'remaining_tickets' => 2, 'start_time' => '21:30'})
screening5 = Screening.new({'film_id' => film4.id, 'remaining_tickets' => 20, 'start_time' => '09:30'})
screening6 = Screening.new({'film_id' => film5.id, 'remaining_tickets' => 4, 'start_time' => '12:30'})

screening1.save
screening2.save
screening3.save
screening4.save
screening5.save
screening6.save

# Note: Pre-existing tickets. Any extra tickets after this will need to be run via customer.buy_ticket!

ticket1 = Ticket.new({'screening_id' => screening1.id, 'customer_id' => customer1.id})
ticket2 = Ticket.new({'screening_id' => screening1.id, 'customer_id' => customer2.id})
ticket3 = Ticket.new({'screening_id' => screening1.id, 'customer_id' => customer3.id})
ticket4 = Ticket.new({'screening_id' => screening1.id, 'customer_id' => customer4.id})
ticket5 = Ticket.new({'screening_id' => screening1.id, 'customer_id' => customer5.id})
ticket6 = Ticket.new({'screening_id' => screening2.id, 'customer_id' => customer2.id})
ticket7 = Ticket.new({'screening_id' => screening3.id, 'customer_id' => customer4.id})
ticket8 = Ticket.new({'screening_id' => screening3.id, 'customer_id' => customer1.id})

ticket1.save
ticket2.save
ticket3.save
ticket4.save
ticket5.save
ticket6.save
ticket7.save
ticket8.save

binding.pry
nil
