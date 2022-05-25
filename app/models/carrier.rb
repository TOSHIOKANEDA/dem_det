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

    def validating(params, record)
      messages = []
      if params.blank?
        messages << "入力データ異常"
      elsif record.blank?
        messages << "指定された条件は、まだデータが揃ってません・・・"
      else
        params.each { |k, v| messages << "未選択の値があります" if params.values_at(k) == [""] }
        messages << "Pick日が起算日よりも前に設定されてます" if params[:start] > params[:finish]
      end
      messages.uniq
    end

  end
end
