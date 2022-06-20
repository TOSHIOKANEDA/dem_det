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
    "着岸日": 3,
    "コンテナ搬出の翌日": 4,
    "コンテナ搬出日": 5,
    "着岸日の翌営業日（東京/大阪OffDockは、OffDock到着の翌日）": 6
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

    def free_validating(params)
      messages = []
      empty_column = "未選択の値があります"
      empty_params = "入力データ異常"
      if params.blank?
        messages << empty_params
      else
        params.each { |k, v| messages << empty_column if ["選択してください", ""].include? params.values_at(k).join() }
        unless [empty_column, empty_params].include?(messages)
          messages << "Pick日が起算日よりも前に設定されてます" if params[:start] > params[:finish]
          fromto_array = [
            [params[:first_from].to_i, params[:first_to].to_i],
            [params[:second_from].to_i, params[:second_to].to_i],
            [params[:third_from].to_i, params[:third_to].to_i],
            [params[:fourth_from].to_i, params[:fourth_to].to_i]
          ]
          fromto_array.each.with_index(1) do |ft, i|
            res = free_from_to(ft[0], ft[1], i)
            messages << res unless res
          end

        end
      end
      messages
    end

    def free_from_to(from, to, i)
      @res = false
      if to == 999 && from > to
        "第#{i}期間で、FromがToよりも後に設定されています"
      elsif to != 999 && from >= to
        "第#{i}期間で、FromがToよりも後に設定されています"
      else
        @res = true
      end
    end

  end
end
