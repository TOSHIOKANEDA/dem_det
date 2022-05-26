class Utils::EachDay
  def initialize(data, range, calc, free)
    @data = data
    # @free = @data[:free].to_i
    @range = range

    # DBからFreeTimeとカウント方法を取得します
    # 同一コンテナであれば、全て同じcalc_methodなのでrecordsの先頭のfree_calc_idを取得
    @calc_method = calc
    @free = free

    @first = false
    @second = false
    @third = false
    # ＝＝＝＝＝＝[レンジのパターン]＝＝＝＝＝
    # DET: 2か3段階構成
    # DEM: 3か4段階構成
    # ＝＝＝＝＝＝＝＝＝＝＝＝

    @first_from = range[4][0]-1
    @first_to= range[4][1]-1

    @second_from = range[5][0]-1
    @second_to = range[5][1]-1

    @third_from = range[6].present? ? range[6][0]-1 : false
    @third_to = range[6].present? ? range[6][1]-1 : false

    @fourth_from = range[7].present? ? range[7][0]-1 : false

  end

  def period
    date_list = []

    start = Date.parse(@data[:start])
    finish = Date.parse(@data[:finish])
    diff = (start - finish).to_i.abs

    holiday_count = HolidayJp.between(@data[:start], @data[:finish]).count

    0.upto(diff) do |d|
      date_list << start + d
      break if start + d == finish
    end
    free_period(date_list)
  end

  def free_period(date_list)
    free_date = []

    case @calc_method
    # case Computing.calcs.keys[@data[:calc].to_i]
    # ここはデータベースから取得する方法をとる
    when "working_day"
      date_list.each do |date|
        if date.workday?
          free_date << date
          @free -= 1
        end
          break if @free <= 0
      end
    when "calender_day"
      date_list.each do |date|
        @free -= 1
        free_date << date
        break if @free <= 0
      end
    end
    charged_period(free_date, date_list)
  end

  def charged_period(free_date, date_list)
    num = date_list.index(free_date.last)
    date_list.slice!(0, num+1)
    @charged_list = date_list
    date_convert
  end

  def date_convert
    first = first_period
    second = @first ? second_period : []
    third = @first && @second && @third_from && @third_to ? third_period : []
    fourth = @first && @second && @third && @third_from && @third_to && @fourth_from ? fourth_period : []
    result_array
  end

  def first_period
    if @charged_list.empty?
      @first_period = []
    elsif @charged_list.size.between?(@first_from, @first_to)
      @first_period = @charged_list
    else
      # @range[4][0], @range[4][1]の範囲外にもデータがある。
      # -1は0開始のため。
      @first_period = @charged_list[@first_from..@first_to]
      @first = true
    end
  end

  def second_period
    if @charged_list.size.between?(@second_from, @second_to)
      # charged_listの合計は@range[5][1]個まで。MAXは@range[5][1]番目。

      @second_period = @charged_list[@second_from..@charged_list.size]
    else

      @second_period = @charged_list[@second_from..@second_to]
      @second = true
    end
  end

  def third_period
    if @charged_list.size.between?(@third_from, @third_to)
      # charged_listの合計は@range[6][1]個まで。MAXは@range[6][1]番目。
      @third_period = @charged_list[@third_from..@charged_list.size]
    else
      @third_period = @charged_list[@third_from..@third_to]
      @third = true
    end
  end

  def fourth_period
    @fourth_period = @charged_list[@fourth_from..@charged_list.size]
  end

  def result_array
    array = [@range[0], @range[1], @range[2], @range[3]]
    if @charged_list.empty?
      array.push([], [], [], [])
    elsif @first_period != [] && @first == false
      array.push(@first_period, [], [], [])
    elsif @first == true && @second == false
      array.push(@first_period, @second_period, [], [])
    elsif @first == true && @second == true && @third == false
      array.push(@first_period, @second_period, @third_period, [])
    elsif @first == true && @second == true && @third == true
      array.push(@first_period, @second_period, @third_period, @fourth_period)
    end
    array
  end

end