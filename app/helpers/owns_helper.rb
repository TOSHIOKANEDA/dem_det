module OwnsHelper
  def price_array
    price_array = []
    1000.times do |n|
      n = n*100
      price_array << n
    end
    price_array
  end

  def option_array
    option_array = []
    999.times do |n|
      n += 1
      option_array << n
    end
    option_array
  end
end
