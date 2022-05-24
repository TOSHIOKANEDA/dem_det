class CarriersController < ApplicationController

  def index
  end

  def search
    records = Carrier.find_carrier(date_params)
    # Tariffを配列に持たせる
    # 例）["SITC", "dem", "20FT DRY", ALL, 3000, 6000, 9000, 12000]
    tariff = Utils::Tariff.new(records).tariff_table
    # 日数のレンジを４段階で抽出する（全て１〜４まである前提）＜＝ない場合の挙動確認
    # 例）["SITC", "dem", "20FT DRY", ALL, [1, 7], [8, 15], [15, 20], [21, 999999]]
    range = Utils::Range.new(records).date_range
    # レンジごとに日数のDate型で配列に格納し、二重配列にする
    # 例）["SITC", "dem", "20FT DRY", ALL, [first date], [second date], [third date], [fourth date] ]
    each_day = Utils::EachDay.new(date_params, range).period
    # レンジごとにtariffとeach_dayの日数を掛けて金額をそれぞれ数値型で格納。レンジがなかった場合には0が入る。
    # 例）["SITC", "dem", "20FT DRY", "ALL", 9000, 24000, 63000, 60000]
    amount = Utils::Amount.new(tariff, each_day).calc

    respond_to do |format| # リクエスト形式によって処理を切り分ける
      format.html { redirect_to :root }
      format.json { render json: break_down(tariff, date_params, each_day, range, amount) }
    end
  end

  private

  def convert(data)
    data == [] ? "" : data
  end

  def port_convert(port)
    # WHL, TSLの条件分岐をする
    port.upcase == "ALL" ? "日本全港" : ""
  end

  def free_period(start, each_day)
    # each_day[4]がfirst_each_dayで、最初の日付の１日前
    each_day.blank? ? ["",""] : [start, (each_day[0] - 1)]
  end

  def date_params
    params.permit(:format, :port, :dem_det, :start, :finish, :calc, :type, :free, :carrier)
  end

  def break_down(tariff, date_params, each_day, range, amount) {
    # ajaxに送り返すdataを、ハッシュで格納
    carrier: tariff[0].upcase,
    dem_det: tariff[1].upcase,
    type: tariff[2],
    port: port_convert(tariff[3]),
    free: date_params[:free],
    free_period: free_period(date_params[:start], each_day[4]),

    first_tariff: tariff[4],
    second_tariff: tariff[5],
    third_tariff: tariff[6],
    fourth_tariff: tariff[7],

    first_range: range[4],
    second_range: range[5],
    third_range: range[6],
    fourth_range: range[7],

    first_each_day: [convert(each_day[4]), each_day[4].size],
    second_each_day: [convert(each_day[5]), each_day[5].size],
    third_each_day: [convert(each_day[6]), each_day[6].size],
    fourth_each_day: [convert(each_day[7]), each_day[7].size],

    first_amount: amount[4],
    second_amount: amount[5],
    third_amount: amount[6],
    fourth_amount: amount[7],
    total_amount: amount[4..7].sum }
  end
end
