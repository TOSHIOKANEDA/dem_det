MAX = 999999
CARRIER = 1
PORT = "ALL"

dem = ["first", "second", "third"]
price_array = [
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
from_array = [1, 5, 10]
to_array = [4, 9, MAX]

# === 9種類のコンテナタイプのレコードを作成する===
1.upto(9) do |type|
  # === first, second, thirdのデータをそれぞれ作っている ===
  0.upto(dem.size - 1){ |i|
    range = dem[i]
    price = price_array[type - 1][i] # 1~9番のコンテナタイプ。１番目は0番目のarrayを読ませるのでマイナス１。
    from = from_array[i]
    to = to_array[i]
    Computing.create!( range: range, price: price, port: PORT, from: from, to: to, carrier_id: CARRIER,
      dem_det: "dem",
      container_type: type,
      free_calc_id: 4
    )
  }
  # ======================================
end
# ======
