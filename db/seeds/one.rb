CARRIER = 1
PORT = "ALL"

# DataSet ================================================
# === DEM ===================================
dem = ["first", "second", "third"]
dem_price_array = [
  [4000, 12000, 20000], #20FT DRY
  [6000, 18000, 30000], #40FT DRY
  [6000, 18000, 30000], #40FT HighCube DRY
  [8000, 24000, 40000], #20FT Reefer
  [12000, 36000, 60000], #40FT HighCube Reefer
  [8000, 24000, 40000], #20FT OpenTop
  [12000, 36000, 60000], #40FT OpenTop
  [8000, 24000, 40000], #20FT FlatRack
  [12000, 36000, 60000] #40FT FlatRack
]
dem_from_array = [1, 5, 10]
dem_to_array = [4, 9, MAX]
# ===========================================

# === DET ===================================
det = ["first", "second", "third"]
det_price_array = [
  [1000, 3000, 5000], #20FT DRY
  [2000, 6000, 10000], #40FT DRY
  [2000, 6000, 10000], #40FT HighCube DRY
  [3000, 9000, 15000], #20FT Reefer
  [6000, 18000, 30000], #40FT HighCube Reefer
  [3000, 9000, 15000], #20FT OpenTop
  [6000, 18000, 30000], #40FT OpenTop
  [3000, 9000, 15000], #20FT FlatRack
  [6000, 18000, 30000] #40FT FlatRack
]
det_from_array = [1, 5, 10]
det_to_array = [4, 9, MAX]
# ===========================================

# RUNTIME ===============================================

# === 9種類のコンテナタイプのレコードを作成する===
1.upto(9) do |type|
  # === DEM first, second, thirdのデータをそれぞれ作っている ===
  0.upto(dem.size - 1){ |i|
    range = dem[i]
    price = dem_price_array[type - 1][i] # 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
    from = dem_from_array[i]
    to = dem_to_array[i]
    free_calc_id = type.between?(1, 3) ? 2 : 3 # typeが1,2,3ならdry。分岐の2番がDEM dry、3はDEM not dry
    Computing.create!( container_type: type, range: range, price: price, port: PORT, from: from, to: to, carrier_id: CARRIER,
      dem_det: "dem",
      free_calc_id: free_calc_id
    )
  }
  # =======================================================

  # === DET first, second, thirdのデータをそれぞれ作っている ===
  0.upto(det.size - 1){ |i|
    range = det[i]
    price = det_price_array[type - 1][i] # 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
    from = det_from_array[i]
    to = det_to_array[i]
    Computing.create!( container_type: type, range: range, price: price, port: PORT, from: from, to: to, carrier_id: CARRIER,
      dem_det: "det",
      free_calc_id: 4 # DETは１択なんで一律で４番
    )
  }
  # =======================================================
end
