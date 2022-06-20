class OwnsController < ApplicationController
  require './lib/utils/amount'
  require './lib/utils/each_day'
  require './lib/utils/range'
  require './lib/utils/tariff'

  def index
  end

  def calcurate
    messages = Computing.free_validating(jquery_params)
    if messages.empty?
      calc_method = jquery_params[:calc]
      free = jquery_params[:free]

      tariff = ["free", "free", "free", "free", jquery_params[:first_amount].to_i, jquery_params[:second_amount].to_i, jquery_params[:third_amount].to_i, jquery_params[:fourth_amount].to_i]
      range = ["free", "free", "free", "free", [jquery_params[:first_from].to_i, jquery_params[:first_to].to_i], [jquery_params[:second_from].to_i, jquery_params[:second_to].to_i], [jquery_params[:third_from].to_i, jquery_params[:third_to].to_i], [jquery_params[:fourth_from].to_i, jquery_params[:fourth_to].to_i]]
      each_day = Utils::EachDay.new(jquery_params, range, calc_method, free).period
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

    respond_to do |format|
      # format.html { redirect_to owns_search_path }
      format.json { render json: break_down(tariff, jquery_params, each_day, range, amount, message, job, free, calc_method) }
    end
  end

  private

  def jquery_params
    params.permit(:format, :start, :finish, :calc, :free, :first_from, :first_to, :first_amount, :second_from, :second_to, :second_amount, :third_from, :third_to, :third_amount, :fourth_from, :fourth_to, :fourth_amount)
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
    if third[0].to_i == 999 && third[1].to_i == 999
      @third = ["--","--"]
    elsif third[1].to_i != 999
      @third = ["#{third[0]}日", "#{third[1]}日"]
    else
      @third = ["#{third[0]}日", "以後ずっと"]
    end
    @fourth = third[1].to_i == 999 ? ["--","--"] : ["#{fourth[0]}日","以後ずっと"]
  end

  def break_down(tariff, jquery_params, each_day, range, amount, message, job, free, calc_method)
    max(range[6], range[7])
    {
    # ajaxに送り返すdataを、ハッシュで格納
    free: free,
    free_period: free_period(jquery_params[:start], jquery_params[:finish], each_day[4], free),

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
