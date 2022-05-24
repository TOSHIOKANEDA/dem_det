class Utils::Range
  def initialize(data)
    @list = data
  end

  def date_range
  # ["SITC", "dem", 1, [1,7], [8,15], [15,20], [21,999999]]
    range = []
    @list.each_with_index do |l, i|
      break if i == 4
      if i == 0
        range << l.name
        range << l.dem_det
        range << l.container_type
        range << l.port
      end
      range << [l.from,l.to] if l.range == raneg_array[i]
    end
    range
  end

  def raneg_array
    ["first", "second", "third", "fourth"]
  end
end