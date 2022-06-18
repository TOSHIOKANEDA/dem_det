class OwnsController < ApplicationController
  require './lib/utils/amount'
  require './lib/utils/each_day'
  require './lib/utils/range'
  require './lib/utils/tariff'

  def index
  end

  def calcurate
    calc_method = date_params[:calc]
    free = date_params[:free]
    start_count = date_params[:start_count]

    tariff = ["free", "free", "free", "free", date_params[:first_amount].to_i, date_params[:second_amount].to_i, date_params[:third_amount].to_i, date_params[:fourth_amount].to_i]
    range = ["free", "free", "free", "free", [date_params[:first_from].to_i, date_params[:first_to].to_i], [date_params[:second_from].to_i, date_params[:second_to].to_i], [date_params[:third_from].to_i, date_params[:third_to].to_i], [date_params[:fourth_from].to_i, date_params[:fourth_to].to_i]]
    each_day = Utils::EachDay.new(date_params, range, calc_method, free).period
    amount = Utils::Amount.new(tariff, each_day).calc
    message = "正常に表示されました"
    job = true

    respond_to do |format|
      format.html { redirect_to owns_search_path }
      format.json { render json: break_down(tariff, date_params, each_day, range, amount, message, job, free, calc_method, start_count) }
    end
  end

  private

  def date_params
    params.permit(:start_count, :format, :start, :finish, :calc, :free, :first_from, :first_to, :first_amount, :second_from, :second_to, :second_amount, :third_from, :third_to, :third_amount, :fourth_from, :fourth_to, :fourth_amount)
  end

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

  def free_period(start, finish, each_day, free)
    # each_day[4]がfirst_each_dayで、最初の日付の１日前
    if free == 0
      ["フリータイムはありません", ""]
    else
      each_day.blank? ? [start, finish] : [start, (each_day[0] - 1)]
    end
  end

  def max(third, fourth)
    @third = third[1].to_i == 999999 ? [third[0], "以後ずっと"] : [third[0], "#{third[1]}日"]
    @fourth = third[1].to_i == 999999 ? ["--","--"] : ["#{fourth[0]}日","以後ずっと"]
  end

  def break_down(tariff, date_params, each_day, range, amount, message, job, free, calc_method, start_count)
    max(range[6], range[7])
    {
    # ajaxに送り返すdataを、ハッシュで格納
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
    calc: calc_method
    }
  end
end
