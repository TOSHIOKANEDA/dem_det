class TariffsController < ApplicationController
  before_action :authenticate_user!

  def new
    @tariff = Tariff.new
  end

  def create
    messages = Tariff.tariff_validating(tariff_params)
    if messages.empty?
      Tariff.create!(tariff_params)
    else
      p messages.join("。")
    end
  end

  private

  def tariff_params
    params.require(:tariff).permit(:name, :calc, :free, :first_from, :first_to, :first_amount, :second_from, :second_to, :second_amount, :third_from, :third_to, :third_amount, :fourth_from, :fourth_to, :fourth_amount).merge(
      user_id: current_user.id)
  end
end
