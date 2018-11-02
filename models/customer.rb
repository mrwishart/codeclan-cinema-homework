require_relative('../db/sqlrunner')

class Customer

  attr_accessor :name
  attr_reader :id, :wallet

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

  # Instance functions

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

end
