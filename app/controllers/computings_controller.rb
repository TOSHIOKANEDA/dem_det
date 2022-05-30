class ComputingsController < ApplicationController
  def index
    @carriers = Carrier.where(active_flg: 0)
  end

  def search
    records = Computing.find_carrier(date_params)
    messages = Computing.validating(date_params, records) # jsからのデータをvalidatingする

    # recordsはfirst~fourthまでの４種類かthirdまでの３種類
    if messages.empty?
      free = records&.first.free_calc.free_day
      calc_method = Computing.calcs.key(records&.first.free_calc.calc_method)
      start_count = Computing.start_counts.key(records&.first.free_calc.start_count)
      # Tariffを配列に持たせる
      # 例）["SITC", "dem", "20FT DRY", ALL, 3000, 6000, 9000, 12000]
      # 4段階目がない例）["SITC", "dem", "20FT DRY", ALL, 3000, 6000, 9000, 0]
      tariff = Utils::Tariff.new(records).tariff_table

      # 日数のレンジを４段階で抽出する
      # 例）["SITC", "dem", "20FT DRY", ALL, [1, 7], [8, 15], [15, 20], [21, 999999]]
      # 4段階目がない例）["SITC", "dem", "20FT DRY", ALL, [1, 10], [11, 15], [15, 999999], [0, 0]]
      range = Utils::Range.new(records).date_range

      # レンジごとに日数のDate型で配列に格納し、二重配列にする
      # 例）["SITC", "dem", "20FT DRY", ALL, [first date], [second date], [third date], [fourth date] ]
      # 4段階目がない例）["SITC", "dem", "20FT DRY", ALL, [first date], [second date], [third date], [] ]
      each_day = Utils::EachDay.new(date_params, range, calc_method, free).period

      # レンジごとにtariffとeach_dayの日数を掛けて金額をそれぞれ数値型で格納。レンジがなかった場合には0が入る。
      # 例）["SITC", "dem", "20FT DRY", "ALL", 9000, 24000, 63000, 60000]
      # 4段階目がない例）["SITC", "dem", "20FT DRY", "ALL", 9000, 24000, 63000, 0]
      amount = Utils::Amount.new(tariff, each_day).calc
      message = "正常に表示されました"
      job = true
    else
      tariff = empty_array[:tariff]
      range = empty_array[:range]
      each_day = empty_array[:each_day]
      amount = empty_array[:amount]
      message = messages.join("。")
      job = false
    end

    respond_to do |format| # リクエスト形式によって処理を切り分ける
      format.html { redirect_to :root }
      format.json { render json: break_down(tariff, date_params, each_day, range, amount, message, job, free, calc_method, start_count) }
    end
  end

  private

  def empty_array 
    {
    tariff: ["", "", "", "", 0, 0, 0, 0],
    range: ["", "", "", "", [0,0], [0,0], [0,0], [0,0]],
    each_day: ["", "", "", "", [], [], [], []],
    amount: ["", "", "", "", 0, 0, 0, 0]
    }
  end

  def convert(data)
    data == [] ? "" : data
  end

  def port_convert(port, carrier)
    # WHL, TSLの条件分岐をする
    case carrier
    when "WanHai"
      port.upcase == "ALL" ? "東京港か大阪港以外" : "東京港か大阪港"
    when "JJ"
      port.upcase == "ALL" ? "那覇以外の日本全港" : "那覇は実装予定ないです"
    when "YangMing"
      port.upcase == "ALL" ? "日本全港（但し：植検必要な貨物で、積み地がUSA/CANADA以外）" : "那覇は実装予定ないです"
    else
      port.upcase == "ALL" ? "日本全港" : ""
    end
  end

  def free_period(start, finish, each_day, free)
    # each_day[4]がfirst_each_dayで、最初の日付の１日前
    if free == 0
      ["フリータイムはありません", ""]
    else
      each_day.blank? ? [start, finish] : [start, (each_day[0] - 1)]
    end
  end

  def date_params
    params.permit(:format, :port, :dem_det, :start, :finish, :type, :carrier)
  end

  def max(third, fourth)
    @third = third[1].to_i == 999999 ? [third[0], "以後ずっと"] : [third[0], "#{third[1]}日"]
    @fourth = third[1].to_i == 999999 ? ["--","--"] : ["#{fourth[0]}日","以後ずっと"]
  end

  def break_down(tariff, date_params, each_day, range, amount, message, job, free, calc_method, start_count)
    max(range[6], range[7])
    {
    # ajaxに送り返すdataを、ハッシュで格納
    carrier: tariff[0],
    dem_det: tariff[1].upcase,
    type: tariff[2],
    port: port_convert(tariff[3], tariff[0]),
    free: free,
    free_period: free_period(date_params[:start], date_params[:finish], each_day[4], free),

    first_tariff: tariff[4],
    second_tariff: tariff[5],
    third_tariff: tariff[6],
    fourth_tariff: tariff[7],

    first_range: range[4],
    second_range: range[5],
    third_range: @third,
    fourth_range: @fourth,

    first_each_day: [convert(each_day[4]), each_day[4].size],
    second_each_day: [convert(each_day[5]), each_day[5].size],
    third_each_day: [convert(each_day[6]), each_day[6].size],
    fourth_each_day: [convert(each_day[7]), each_day[7].size],

    first_amount: amount[4],
    second_amount: amount[5],
    third_amount: amount[6],
    fourth_amount: amount[7],
    total_amount: amount[4..7].sum,

    message: message,
    job: job,
    calc: calc_method,
    start_count: start_count
  }
  end
end
