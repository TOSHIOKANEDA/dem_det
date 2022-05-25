class Utils::Amount
  def initialize(tariff, each_day)
    @total_price = [tariff[0], tariff[1], tariff[2], tariff[3]]
    @tariff = tariff
    @detail_dates = [each_day[4]&.size, each_day[5]&.size, each_day[6]&.size, each_day[7]&.size]
  end

  def calc
    #tariffは４番目から開始で７まで ["SITC", "dem", 1, ALL, 3000, 6000, 9000, 12000]
    @detail_dates.each.with_index(4) do |num, i|
      price = num*@tariff[i].to_i
      @total_price << price
    end
    @total_price
  end
end