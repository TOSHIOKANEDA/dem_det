class Tariff < ApplicationRecord
  belongs_to :user
  class << self

    def tariff_validating(params)
      messages = []
      empty_column = "未選択の値があります"
      empty_params = "入力データ異常"
      if params.blank?
        messages << empty_params
      else
        params.each do |k, v|
          messages << empty_column if ["", "選択してください"].include? params.values_at(k).join()
        end
      end
      messages.uniq
    end
  end
end
