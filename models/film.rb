require_relative('../db/sqlrunner')
require_relative('./customer')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(params)
    @id = params['id'].to_i if params['id']
    @title = params['title']
    @price = params['price'].to_f.round(2)
  end

  # Class functions

  def self.delete_all
    sql = "DELETE FROM films"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM films WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    found_film = Film.new(result[0])
    return found_film
  end

  # Instance functions

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE films SET (title, price) = ($1, $2) WHERE id = $3"
    values = [@title, @price, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

  # Non-CRUD Instance functions

  def customers()
    sql = "SELECT customers.*
    FROM customers
    INNER JOIN tickets
    ON tickets.customer_id = customers.id
    INNER JOIN screenings
    ON tickets.screening_id = screenings.id
    WHERE tickets.screening_id = $1"

    values = [@id]

    results = SqlRunner.run(sql, values)
    return nil if results.count == 0

    found_customers = results.map{|customer| Customer.new(customer)}

    return found_customers
  end

  def screenings()
    sql = "SELECT screenings.*
    FROM screenings
    WHERE screenings.film_id = $1
    ORDER BY screenings.start_time;"

    values = [@id]

    results = SqlRunner.run(sql, values)
    return nil if results.count == 0

    found_screenings = results.map{|screening| Screening.new(screening)}

    return found_screenings
  end

  def most_popular_screening()
    sql = "SELECT *
    FROM screenings
    WHERE id =
    (SELECT screening_id
      FROM tickets
      WHERE screening_id
      IN
      (SELECT       id
        FROM     screenings
        WHERE film_id = $1)
      GROUP BY screening_id
      ORDER BY COUNT(screening_id) DESC
      LIMIT 1)
    ;"

    values = [@id]

    result = SqlRunner.run(sql, values)
    return nil if result.count == 0

    return Screening.new(result[0])
  end


  def no_of_screenings
    sql = "SELECT COUNT (*) FROM screenings WHERE film_id = $1;"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results[0]['count'].to_i
  end

  def no_of_tickets_sold
    sql = "SELECT COUNT(*)
    FROM tickets
    WHERE screening_id
    IN
    (SELECT       id
    FROM     screenings
    WHERE film_id = $1);"
    values = [@id]
    results = SqlRunner.run(sql, values)
    return results[0]['count'].to_i
  end

end
