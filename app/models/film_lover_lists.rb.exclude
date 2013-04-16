class FilmLoverLists 

  attr_reader :key

  FilmLists = [:watched, :loved, :unloved, :owned]

  def initialize(key)
    @key = key
  end

  def [](list)
    @lists ||= {}
    FilmLists.each do |list|
      @lists[list] =  Redis::SetStore.new("#{key}:#{list}")
    end
    @lists[list]
  end
end 