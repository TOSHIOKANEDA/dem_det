class Utils::Range
  def initialize(data)
    @list = data
  end

  def date_range
    range = []
    @list.each_with_index do |l, i|
      if i == 0
        range << l.carrier.name
        range << l.dem_det
        range << l.container_type
        range << l.port
      end
      range << [l.from,l.to] if l.range == raneg_array[i]
      # 合計で８つの値がprice配列に入れる。７つだったり不足分だけ0を入れる処理。
      (8 - range.size).times {range << [0,0]} if i == @list.size - 1
    end
    range
  end

  def raneg_array
    ["first", "second", "third", "fourth"]
  end
end