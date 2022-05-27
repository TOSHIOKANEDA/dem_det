@carrier = 4
@port = "ALL"

# DataSet ================================================
# === DEM ===================================

dry_ranges = ["first", "second", "third"]
reefer_ranges = ["first", "second", "third", "fourth"]
dry_prices = [
  [1, 3000, 6000, 12000], #20FT DRY
  [2, 4500, 9000, 18000], #40FT DRY
  [3, 4500, 9000, 18000], #40FT HighCube DRY
  [6, 9000, 18000, 36000], #20FT OpenTop
  [7, 13500, 27000, 54000], #40FT OpenTop
  [8, 9000, 18000, 36000], #20FT FlatRack
  [9, 13500, 27000, 54000] #40FT FlatRack
]
reefer_prices = [
  [4, 5000, 9000, 18000, 36000], #20FT Reefer
  [5, 5000, 13500, 27000, 54000], #40FT HighCube Reefer
]

dem_from_dry = [1, 5, 10]
dem_to_dry = [4, 9, MAX]
dem_from_ref = [1, 5, 9, 14]
dem_to_ref = [4, 8, 13, MAX]

@dem_dry_id = 8
@dem_rf_id = 1
@dem_sp_id = 6
# ===========================================

# === DET ===================================
det = ["first", "second"]
det_price_array = [
  [600, 1200], #20FT DRY
  [1200, 2400], #40FT DRY
  [1200, 2400], #40FT HighCube DRY
  [3500, 10500], #20FT Reefer
  [7000, 21000], #40FT HighCube Reefer
  [3500, 10500], #20FT OpenTop
  [7000, 21000], #40FT OpenTop
  [3500, 10500], #20FT FlatRack
  [7000, 21000] #40FT FlatRack
]
det_from_array = [1, 6]
det_to_array = [5, MAX]
det_dry_id = 9
det_not_dry_id = 7
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


# === REF以外の7種類のコンテナタイプのレコードを作成する===
dry_prices.each do |price_array|
  dry_ranges.each.with_index do |range, i|
    making_dem_range(price_array[0], price_array[i+1], range, dem_from_dry[i], dem_to_dry[i])
  end
end

reefer_prices.each do |price_array|
  reefer_ranges.each.with_index do |range, i|
    making_dem_range(price_array[0], price_array[i+1], range, dem_from_ref[i], dem_to_ref[i])
  end
end


# === DET first, second, third, fourthまでのデータをそれぞれ作っている ===
1.upto(9) {|type|
  0.upto(det.size - 1){ |i|
    range = det[i]
    price = det_price_array[type - 1][i] # 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
    from = det_from_array[i]
    to = det_to_array[i]
    free_calc_id = type.between?(1, 3) ? det_dry_id : det_not_dry_id
    Computing.create!( container_type: type, range: range, price: price, port: @port, from: from, to: to, carrier_id: @carrier,
      dem_det: "det",
      free_calc_id: free_calc_id
    )
  }
}
