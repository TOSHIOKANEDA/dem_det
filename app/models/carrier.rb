class Carrier < ApplicationRecord
  TYPE = {
    "20FT DRY":1,
    "40FT DRY":2,
    "40FT HighCube DRY":3,
    "20FT Reefer":4,
    "40FT HighCube Reefer":5,
    "20FT OpenTop":6,
    "40FT OpenTop":7,
    "20FT FlatRack":8,
    "40FT FlatRack":9
  }

  enum container_type: TYPE
  enum calc: {calender_day: 0, working_day: 1}

  class << self
    def find_carrier(data)
      Carrier.where(
        name: data[:carrier],
        dem_det: data[:dem_det],
        port: data[:port],
        container_type: data[:type].to_i
      )
    end

    def compute(data)
      dem_start = Date.parse(data[:dem_start])
      dem_finish = Date.parse(data[:dem_finish])
      free_time = data[:free].to_i
      carrier = data[:carrier].upcase
      type = data[:type]

      case data[:carrier]
      when "SITC"
        total_count = working_dayscount(dem_start, dem_finish)
        @tariff = tariff(carrier, type)
        p dem_range(total_count, free_time, type)
      when "Maersk"
      else
      end

    end

    def dem_range(total_count, free_time, type)
      charged_count = total_count - free_time
      if charged_count < 0
        "no charge"
      elsif charged_count.between?(1, 3)
        one_stage(charged_count, type, "first")
      elsif charged_count.between?(4, 7)
        first_range = one_stage(4, type, "first")
        second_range = one_stage((charged_count - 4), type, "second")
        first_range + second_range
      elsif charged_count.between?(8, 11)
        first_range = one_stage(4, type, "first")
        second_range = one_stage((charged_count - 4), type, "second")
        third_range = one_stage((charged_count - 8), type, "third")
        first_range + second_range + third_range
      elsif charged_count.between?(12, 19)
        first_range = one_stage(4, type, "first")
        second_range = one_stage((charged_count - 4), type, "second")
        third_range = one_stage((charged_count - 8), type, "third")
        third_range = one_stage((charged_count - 8), type, "third")
        first_range + second_range + third_range
      elsif charged_count > 19
      end
      
    end


    def one_stage(charged_count, type)
      case type
      when "1"
        3000*charged_count
      when "2"
        4500*charged_count
      when "3"
        4500*charged_count
      when "4"
        5000*charged_count
      when "5"
        5000*charged_count
      when "6"
        9000*charged_count
      when "7"
        13500*charged_count
      when "8"
        9000*charged_count
      when "9"
        13500*charged_count
      else
      end
    end

    def tariff(carrier, type, range)
      # DBに保管したら、↓で検索
      # Carrier.where(name: carrier, type: type, range: range)
      carrier_type = [carrier, type]
      case carrier_type
      when ["SITC", "1"]
        3000 if range == "first"
        6000 if range == "second"
        9000 if range == "third"
        12000 if range == "fourth"
      when ["SITC", "2"]
        4500
      when ["SITC", "3"]
        4500
      when ["SITC", "4"]
        5000
      when ["SITC", "5"]
        5000
      when ["SITC", "6"]
        9000
      when ["SITC", "7"]
        13500
      when ["SITC", "8"]
        9000
      when ["SITC", "9"]
        13500
      else
      end
    end
  end
end
