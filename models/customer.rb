require_relative('../db/sqlrunner')
require_relative('./film')
require_relative('./ticket')

class Customer

  attr_accessor :name
  attr_reader :id

  def initialize( params )
    @id = params['id'].to_i if params['id']
    @name = params['name'].downcase.capitalize
    @wallet = params['wallet'].to_f.round(2)
  end

  # Class functions

  def self.delete_all
    sql = "DELETE FROM customers"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM customers WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    return nil if result.count == 0
    found_customer = Customer.new(result[0])
    return found_customer
  end

  def self.find_by_name(name)
    sql = "SELECT * FROM customers WHERE name = $1"
    values = [name.downcase.capitalize]
    results = SqlRunner.run(sql, values)
    return nil if results.count == 0
    found_customers = results.map {|customer| Customer.new(customer)}
    return found_customers
  end

  # CRUD Instance functions

  def save()
    sql = "INSERT INTO customers (name, wallet) VALUES ($1, $2) RETURNING id"
    values = [@name, @wallet]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE customers SET (name, wallet) = ($1, $2) WHERE id = $3"
    values = [@name, @wallet, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM customers WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Non-CRUD Instance functions

  # Note: With addition of screenings, updated film method to give the title of the film and start time.

  def screenings()
    sql = "SELECT screenings.*
    FROM screenings
    INNER JOIN tickets
    ON screenings.id = tickets.screening_id
    WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return nil if results.count == 0
    found_screenings = results.map{|film| Screening.new(film)}
    return found_screenings

  end

  def films()
    sql = "SELECT films.*
    FROM films
    INNER JOIN screenings
    ON screenings.film_id = films.id
    INNER JOIN tickets
    ON tickets.screening_id = screenings.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return nil if results.count == 0
    found_films = results.map{|film| Film.new(film)}
    return found_films
  end

# UPDATE: Changed to screening; created function for screening that checks film price
  def buy_ticket(screening)

    #Exit function if customer can't afford or tickets ran out
    return nil if !(can_afford?(screening.price) && screening.tickets_available?)
    #Reduce money
    spend_money(screening.price)
    #Update customer on db
    update
    #Create ticket
    new_ticket = Ticket.new({'screening_id' => screening.id, 'customer_id' => @id})
    #Save ticket to database
    new_ticket.save
    #Remove ticket from screening
    screening.sold_ticket
    #Update screening
    screening.update

  end

  def no_of_tickets_bought
    sql = "SELECT COUNT (*) FROM tickets WHERE customer_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results[0]['count'].to_i
  end

  def can_afford?(price)
    return @wallet >= price
  end

  def spend_money(amount)
    @wallet -= amount if can_afford?(amount)
  end

end
