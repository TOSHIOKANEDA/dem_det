module ApplicationHelper
  def price_array
    price_array = ["選択してください"]
    1000.times do |n|
      n = n*100
      price_array << n
    end
    price_array
  end

  def option_array(n)
    option_array = ["選択してください"]
    n.upto(999) {|n| option_array << n}
    option_array
  end

  def calc_array
    option_array = ["選択してください", "calender_day", "working_day"]
  end
end
