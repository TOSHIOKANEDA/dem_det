class OwnsController < ApplicationController
  require './lib/utils/amount'
  require './lib/utils/each_day'
  require './lib/utils/range'
  require './lib/utils/tariff'

  def index
    @appear = false
    if user_signed_in?
      @tariffs = Tariff.where(user_id: current_user.id).includes(:user)
      @appear = true unless @tariffs.blank?
    end
    params[:id].present? && user_signed_in? ? copy_values(params[:id], params[:user_id]) : no_values
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
      format.json { render json: break_down(tariff, jquery_params, each_day, range, amount, message, job, free, calc_method) }
    end
  end

  private

  def copy_values(tariff_id, user_id)
    if user_id.to_i == current_user.id
      tariff = Tariff.find(tariff_id)
      @copy_value = {
        calc: tariff.calc, 
        free: tariff.free, 
        first_from: tariff.first_from, 
        first_to: tariff.first_to, 
        first_amount: tariff.first_amount, 
        second_from: tariff.second_from, 
        second_to: tariff.second_to, 
        second_amount: tariff.second_amount, 
        third_from: tariff.third_from, 
        third_to: tariff.third_to, 
        third_amount: tariff.third_amount, 
        fourth_from: tariff.fourth_from, 
        fourth_to: tariff.fourth_to, 
        fourth_amount: tariff.fourth_amount
      }
    else
      no_values
    end
  end

  def no_values
    @copy_value = {
      calc: "選択してください",
      free: "選択してください",
      first_from: "1", 
      first_to: "0",
      first_amount: "選択してください",
      second_from: "0",
      second_to: "0",
      second_amount: "選択してください",
      third_from: "0",
      third_to: "0",
      third_amount: "選択してください",
      fourth_from: "0",
      fourth_to: "999",
      fourth_amount: "選択してください"
    }
  end

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
