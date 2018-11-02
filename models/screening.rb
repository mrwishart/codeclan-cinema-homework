require_relative('../db/sqlrunner')
require_relative('./customer')

class Screening

  attr_accessor :film_id, :remaining_tickets, :start_time

  attr_reader :id

  def initialize( params )
    @id = params['id'].to_i if params['id']
    @film_id = params['film_id'].to_i
    @remaining_tickets = params['remaining_tickets'].to_i
    @start_time = params['start_time']
  end

  # Class functions

  def self.delete_all
    sql = "DELETE FROM screenings"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM screenings WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    found_screening = Film.new(result[0])
    return found_screening
  end

  def self.all
    sql = "SELECT * FROM screenings"
    results = SqlRunner.run(sql)
    return results.map{|screening| Screening.new(screening)}
  end

  # Instance functions

  def save()
    sql = "INSERT INTO screenings (film_id, remaining_tickets, start_time) VALUES ($1, $2, $3) RETURNING id"
    values = [@film_id, @remaining_tickets, @start_time]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE screenings SET (film_id, remaining_tickets, start_time) = ($1, $2, $3) WHERE id = $4"
    values = [@film_id, @remaining_tickets, @start_time, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM screeningss WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  def customers
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    WHERE tickets.screening_id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return nil if results.count == 0

    found_customers = results.map{|customer| Customer.new(customer)}

    return found_customers

  end

  def tickets_sold
    sql = "SELECT COUNT (*) FROM tickets WHERE screening_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results[0]['count'].to_i
  end

  def price
    sql = "SELECT * FROM films WHERE id = $1"
    values = [@film_id]
    results = SqlRunner.run(sql, values)
    return results[0]['price'].to_f.round(2)
  end

  def remove_ticket
    @remaining_tickets -= 1 if tickets_available?
  end

  def tickets_available?
    return @remaining_tickets > 0
  end

end
