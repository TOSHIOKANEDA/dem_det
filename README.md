# README

Process to go

1) 日付をajaxで取得
2) calender day・wordking dayかを取得
3) キャリアのdefaultを登録（SITCから取得）

1. 計算方法
  1) DBに保存するもの
    - name(SITC, MAERSK..)
    - type(1..9)
    - dem_det(dem, det)
    - range(first, second...last)
    - price
    - port

  2) firstからlastまでhashでfirstからfourthまで読む price{type: 1, first: 3000, second: 6000, third: 9000, fourth: 12000}
  3) 日数のrangeを読むrange{type: 1, first: [1,7], second: [8,14], third[15,20], fourth[21]} 数値はFreeTime超過後の日数を記入
  4) range別の日数をhashに格納するrange_date{first: 7, second: 6, third: 5, fourth: 7}

  total_days <= data[:freetime]
    "chargeなし"
  total_days.between(range[:first][:first], range[:first][:last])
    first_calc(total_days)
  total_days.between(range[:second][:first], range[:second][:last])
    first_calc(range[:first][:last])) 7
    second_calc(totaldays - range[:first][:last]))
  range[:fourth] >= total_days
    first_params = range[:first][:last]
    second_params = range[:second][:last] - range[:second][:first]
    third_params = range[:third][:last] - range[:third][:first]
    fourth_params = total_days - (first_params + second_params + third_params + fourth_params)
    25
  end

  配列のイメージ
  {
  first_calc(first_params) 7
  second_calc(second_params) 14-8 = 6
  thrid_calc(third_params) 20-15 = 5
  fourth_calc(fourth_params) 25-(7+6+5) = 7
  }

  5) 掛け算して合計を求める
  price[:first] * range_date[:first]
  price[:second] * range_date[:second]





