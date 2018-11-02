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

  # Instance functions

  def save()
    sql = "INSERT INTO films (title, price) VALUES ($1, $2) RETURNING id"
    values = [@title, @price]
    result = SqlRunner.run(sql, values)
    @id = result[0]['id'].to_i
  end

  def delete()
    sql = "DELETE FROM films WHERE id = $1"
    values = [@id]
    SqlRunner.run(sql, values)
  end

end
