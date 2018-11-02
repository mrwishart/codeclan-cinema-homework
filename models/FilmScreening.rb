class FilmScreening

  attr_accessor :title, :start_time

  def initialize( params )
    @title = params['title']
    @start_time = params['start_time']
  end

end
