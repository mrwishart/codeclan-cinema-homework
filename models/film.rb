require_relative('../db/sqlrunner')

class Film

  attr_accessor :title, :price
  attr_reader :id

  def initialize(params)
    @id = params['id'].to_i if params['id']
    @title = params['title']
    @price = params['price'].to_f.round(2)
  end

end
