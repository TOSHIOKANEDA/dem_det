class Utils::Tariff
  def initialize(data)
    @list = data
  end

  def tariff_table
    price = []
    @list.each_with_index do |l, i|
      break if i == 4
      if i == 0
        price << l.name
        price << l.dem_det
        price << l.container_type
        price << l.port
      end
      price << l.price if l.range == raneg_array[i]
    end
    price
  end

  def raneg_array
    ["first", "second", "third", "fourth"]
  end
end