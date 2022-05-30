@carrier = 6
@port = "ALL"

# DataSet ================================================
# === DEM ===================================

ranges = ["first", "second", "third"]
prices = [
  [1, 5000, 9000, 17000], #20FT DRY
  [2, 10000, 14000, 26000], #40FT DRY
  [3, 10000, 14000, 26000], #40FT HighCube DRY
  [4, 12000, 23000, 37000], #20FT Reefer
  [5, 24000, 35000, 56000], #40FT HighCube Reefer
  [6, 12000, 23000, 37000], #20FT OpenTop
  [7, 24000, 35000, 56000], #40FT OpenTop
  [8, 12000, 23000, 37000], #20FT FlatRack
  [9, 24000, 35000, 56000] #40FT FlatRack
]

dem_from_dry = [1, 4, 7]
dem_to_dry = [3, 6, MAX]

@dem_dry_id = 15
@dem_rf_id = 16
@dem_sp_id = 17
# ===========================================

# === DET ===================================
det = ["first", "second"]
det_price_array = [
  [1600, 2700], #20FT DRY
  [3200, 5400], #40FT DRY
  [3200, 5400], #40FT HighCube DRY
  [7500, 21500], #20FT Reefer
  [8000, 22000], #40FT HighCube Reefer
  [7500, 21500], #20FT OpenTop
  [8000, 22000], #40FT OpenTop
  [7500, 21500], #20FT FlatRack
  [8000, 22000] #40FT FlatRack
]
det_from_array = [1, 6]
det_to_array = [5, MAX]
det_from_array_sp = [1, 5]
det_to_array_sp = [4, MAX]

det_dry_id = 18
det_not_dry_id = 13
# ===========================================

# RUNTIME ===============================================

def free_time_convert(type)
  if type.between?(1,3)
    @dem_dry_id
  elsif type.between?(4,5)
    @dem_rf_id
  elsif type.between?(6,9)
    @dem_sp_id
  else
    p "エラーーーーーーー"
  end
end

def making_dem_range(type, price, range, from, to)
  free_calc_id = free_time_convert(type) # typeが1,2,3ならdry。分岐の5番がDEM dry、6はDEM not dry
  Computing.create!( container_type: type, range: range, price: price, from: from, to: to, carrier_id: @carrier,
    dem_det: "dem",
    port: @port,
    free_calc_id: free_calc_id
  )
end


# === SP以外の7種類のコンテナタイプのレコードを作成する===
prices.each do |price_array|
  ranges.each.with_index do |range, i|
    making_dem_range(price_array[0], price_array[i+1], range, dem_from_dry[i], dem_to_dry[i])
  end
end

# === DET first, second, third, fourthまでのデータをそれぞれ作っている ===
1.upto(9) {|type|
  0.upto(det.size - 1){ |i|
    range = det[i]
    price = det_price_array[type - 1][i] # 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
    from = type.between?(1, 3) ? det_from_array[i] : det_from_array_sp[i]
    to = type.between?(1, 3) ? det_to_array[i] : det_to_array_sp[i]
    free_calc_id = type.between?(1, 3) ? det_dry_id : det_not_dry_id
    Computing.create!( container_type: type, range: range, price: price, port: @port, from: from, to: to, carrier_id: @carrier,
      dem_det: "det",
      free_calc_id: free_calc_id
    )
  }
}
