# ====[usage]====

# calc_method
# calender_day: 0
# working_day: 1

# start_count
# "[DEM]出港日の翌日": 0
# "[DEM]着岸日の翌日": 1
# "[DEM]本船一括搬入日": 2
# "[DEM]着岸日": 3
# "[DET]コンテナ搬出の翌日" 4

# ====[usage]====
# IDなので１スタートに注意。順番を絶対に変えてはいけない。それぞれの船社.rbでIDを直書きしています。
# Reeferの0日DEMを想定
# 1
FreeCalc.create!(free_day: 0, calc_method: 0, start_count: 1)

# ONEを想定[DEM,DET]
# 2
FreeCalc.create!(free_day: 6, calc_method: 1, start_count: 1) # DEM dry
# 3
FreeCalc.create!(free_day: 4, calc_method: 1, start_count: 1) # DEM not dry
# 4
FreeCalc.create!(free_day: 4, calc_method: 1, start_count: 4) # DET all

# WHLを想定[DEM,DET]
# 5
FreeCalc.create!(free_day: 5, calc_method: 0, start_count: 0) # DEM dry
# 6
FreeCalc.create!(free_day: 4, calc_method: 0, start_count: 0) # DEM not dry
# 7
FreeCalc.create!(free_day: 3, calc_method: 0, start_count: 4) # DET all

# HASCOを想定[DEM,DET]
# 8
FreeCalc.create!(free_day: 7, calc_method: 0, start_count: 0) # DEM dry
# 6
# FreeCalc.create!(free_day: 4, calc_method: 0, start_count: 0) # DEM OT/FR WHLで設定済み
# 0
# FreeCalc.create!(free_day: 0, calc_method: 0, start_count: 0) # DEM RF デフォルトで設定済み
# 9
FreeCalc.create!(free_day: 5, calc_method: 0, start_count: 4) # DET dry
# 7
# FreeCalc.create!(free_day: 3, calc_method: 0, start_count: 4) # DET not dry WHLで設定済み


# SINOTRANSを想定[DEM,DET]
# 10
FreeCalc.create!(free_day: 7, calc_method: 0, start_count: 3) # DEM dry
# 11
FreeCalc.create!(free_day: 4, calc_method: 0, start_count: 3) # DEM not dry
# FreeCalc.create!(free_day: 5, calc_method: 0, start_count: 4) # DET all HASCOで設定済み
# FreeCalc.create!(free_day: 3, calc_method: 0, start_count: 4) # DET not dry WHLで設定済み
