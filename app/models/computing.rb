class Computing < ApplicationRecord
  belongs_to :carrier
  belongs_to :free_calc
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
  enum start_count: {
    "出港日の翌日": 0, 
    "着岸日の翌日": 1, 
    "本船一括搬入日": 2,
    "[DEM]着岸日": 3,
    "[DET]コンテナ搬出の翌日": 4
  }

  class << self
    def find_carrier(data)
      Computing.where(
        carrier_id: data[:carrier],
        dem_det: data[:dem_det],
        port: data[:port],
        container_type: data[:type].to_i
      )
    end

    def validating(params, record)
      messages = []
      if params.blank?
        messages << "入力データ異常"
      elsif record.blank? && params[:carrier].present?
        carrier = Carrier.find(params[:carrier]).name
        case [params[:port], params[:dem_det], carrier]
        when ["[DEM ONLY]東京港/大阪港のみ", "det", "WanHai"]
          messages << "「#{params[:port]}」はDET（ディテンション）でしか選択できないです"
        else
          messages << "指定された条件は、まだデータが揃ってません・・・"
        end
      else
        params.each { |k, v| messages << "未選択の値があります" if params.values_at(k) == [""] }
        messages << "Pick日が起算日よりも前に設定されてます" if params[:start] > params[:finish]
      end
      messages.uniq
    end

  end
end
