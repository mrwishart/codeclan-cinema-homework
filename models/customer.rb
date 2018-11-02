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

  def films()
    sql = "SELECT films.*
    FROM films
    INNER JOIN tickets
    ON tickets.film_id = films.id
    WHERE tickets.customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return nil if results.count == 0
    found_films = results.map{|film| Film.new(film)}
    return found_films
  end

  def buy_ticket(film)

    #Exit function if customer can't afford
    return nil if !can_afford?(film.price)
    #Reduce money
    spend_money(film.price)
    #Create ticket
    new_ticket = Ticket.new({'film_id' => film.id, 'customer_id' => @id})
    #Save ticket to database
    new_ticket.save

  end

  def no_of_tickets_bought
    sql = "SELECT * FROM tickets WHERE customer_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results.count
  end

  def can_afford?(price)
    return @wallet >= price
  end

  def spend_money(amount)
    @wallet -= amount if can_afford?(amount)
  end

end
