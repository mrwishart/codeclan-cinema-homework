require_relative('../db/sqlrunner')

class Ticket

  attr_accessor :film_id, :customer_id
  attr_reader :id

  def initialize( params )
    @id = params['id'].to_i if params['id']
    @film_id = params['film_id'].to_i
    @customer_id = params['customer_id'].to_i
  end

  def save()
    sql = "INSERT INTO tickets (film_id, customer_id) VALUES ($1, $2) RETURNING id"
    values = [@film_id, @customer_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

end
