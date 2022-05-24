class CarriersController < ApplicationController


  def index
  end

  def new
    @carrier = Carrier.new
  end

  def search

    # xxx日
    # 1. 日数分割をする[配列でとる]
    # 2. Tariffを割り当てる
    # 3. 合計を算出する
 
    records = Carrier.find_carrier(date_params)

      # ["SITC", "dem", "20FT DRY", ALL, 3000, 6000, 9000, 12000]
      tariff = Utils::Tariff.new(records).tariff_table
p tariff
      # ["SITC", "dem", "20FT DRY", ALL, [1, 7], [8, 15], [15, 20], [21, 999999]]
      range = Utils::Range.new(records).date_range
p range
      # ["SITC", "dem", "20FT DRY", ALL, [first date], [second date], [third date], [fourth date] ]
      each_day = Utils::EachDay.new(date_params, range).period
p each_day
      # ["SITC", "dem", "20FT DRY", "ALL", 9000, 24000, 63000, 60000]
      amount = Utils::Amount.new(tariff, each_day).calc
p amount

# p Carrier.container_types.keys[tariff[2].to_i].to_s

  break_down = {
    carrier: tariff[0],
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
    total_amount: amount[4..7].sum
  }
    respond_to do |format| # リクエスト形式によって処理を切り分ける
      format.html { redirect_to :root }
      format.json { render json: break_down }
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
    params.permit(:port, :dem_det, :start, :finish, :calc, :type, :free, :carrier)
  end
end
