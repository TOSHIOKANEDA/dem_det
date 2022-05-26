class Utils::Tariff
  def initialize(data)
    @list = data
  end

  def tariff_table
    price = []
    @list.each_with_index do |l, i|
      if i == 0
        price << l.carrier.name
        price << l.dem_det
        price << l.container_type
        price << l.port
      end
      price << l.price if l.range == raneg_array[i]
      # 合計で８つの値がprice配列に入れる。７つだったり不足分だけ0を入れる処理。
      (8 - price.size).times {price << 0} if i == @list.size - 1
    end
    price
  end

  def raneg_array
    ["first", "second", "third", "fourth"]
  end
end