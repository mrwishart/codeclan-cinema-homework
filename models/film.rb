require_relative('../db/sqlrunner')

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

end
