# DataSet ================================================
# === 基本情報 ================================
@carrier = 2
@dem_dry = 5
@dem_not_dry = 6
@det_id = 7
@dem_port_array = ["ALL","[DEM ONLY]東京港/大阪港のみ"]
@det_port_array = ["ALL"]

# === DEM ===================================
@dem = ["first", "second", "third"]
@dem_price_array = [[
# port = ALL
  [7000, 13000, 20500], #20FT DRY
  [14000, 26000, 41000], #40FT DRY
  [14000, 26000, 41000], #40FT HighCube DRY
  [12000, 24000, 36000], #20FT Reefer
  [24000, 36000, 48000], #40FT HighCube Reefer
  [12000, 24000, 36000], #20FT OpenTop
  [24000, 36000, 48000], #40FT OpenTop
  [12000, 24000, 36000], #20FT FlatRack
  [24000, 36000, 48000] #40FT FlatRack
  ],
  [
# port = "[DEM ONLY]東京港/大阪港のみ"
  [7500, 13500, 22500], #20FT DRY
  [15000, 27000, 45000], #40FT DRY
  [15000, 27000, 45000], #40FT HighCube DRY
  [12000, 24000, 36000], #20FT Reefer
  [24000, 36000, 48000], #40FT HighCube Reefer
  [12000, 24000, 36000], #20FT OpenTop
  [24000, 36000, 48000], #40FT OpenTop
  [12000, 24000, 36000], #20FT FlatRack
  [24000, 36000, 48000] #40FT FlatRack
  ]
]
@dem_from_array = [1, 4, 7]
@dem_to_array = [3, 6, MAX]
# ===========================================

# === DET ===================================
@det = ["first", "second"]
@det_price_array = [
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
@det_from_array = [1, 5]
@det_to_array = [4, MAX]
# ===========================================

# DET/DEM ===============================================
# DEM first, second, thirdのデータをそれぞれ作っている =======
def making_dem_range(type, i, port)
  range = @dem[i]
  price = port == "[DEM ONLY]東京港/大阪港のみ" ? @dem_price_array[1][type - 1][i] : @dem_price_array[0][type - 1][i]# 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
  from = @dem_from_array[i]
  to = @dem_to_array[i]
  free_calc_id = type.between?(1, 3) ? @dem_dry : @dem_not_dry # typeが1,2,3ならdry。分岐の5番がDEM dry、6はDEM not dry
  Computing.create!( container_type: type, range: range, price: price, from: from, to: to, carrier_id: @carrier,
    dem_det: "dem",
    port: port,
    free_calc_id: free_calc_id
  )
end

# DET first, second のデータをそれぞれ作っている =======
def making_det_range(type, i, port)
  range = @det[i]
  price = @det_price_array[type - 1][i]
  from = @det_from_array[i]
  to = @det_to_array[i]
  free_calc_id = @det_id
  Computing.create!( container_type: type, range: range, price: price, from: from, to: to, carrier_id: carrier,
    dem_det: "det",
    port: "ALL",
    free_calc_id: free_calc_id
  )
end

# RUNTIME ===============================================

# === 9種類のコンテナタイプのレコードを作成する===
1.upto(9) do |type|
  @dem_port_array.each do |port|
    0.upto(@dem.size - 1){ |i| making_dem_range(type, i, port) }
  end
  @det_port_array.each do |port|
    0.upto(@det.size - 1){ |i| making_dem_range(type, i, port) }
  end
end
