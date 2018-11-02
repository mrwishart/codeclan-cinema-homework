require_relative('../db/sqlrunner')

class Ticket

  attr_accessor :screening_id, :customer_id
  attr_reader :id

  def initialize( params )
    @id = params['id'].to_i if params['id']
    @screening_id = params['screening_id'].to_i
    @customer_id = params['customer_id'].to_i
  end

  # Class functions

  def self.delete_all
    sql = "DELETE FROM tickets"
    SqlRunner.run(sql)
  end

  def self.find_by_id(id)
    sql = "SELECT * FROM tickets WHERE id = $1"
    values = [id]
    result = SqlRunner.run(sql, values)
    found_ticket = Ticket.new(result[0])
    return found_ticket
  end

  # Instance functions

  def save()
    sql = "INSERT INTO tickets (screening_id, customer_id) VALUES ($1, $2) RETURNING id"
    values = [@screening_id, @customer_id]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def update()
    sql = "UPDATE tickets SET (screening_id, customer_id) = ($1, $2) WHERE id = $3"
    values = [@screening_id, @customer_id, @id]
    SqlRunner.run(sql, values)
  end

  def delete()
    sql = "DELETE FROM tickets WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
