class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
  start_date = Time.zone.parse('2000-01-01 00:00:00')
  end_date = Time.zone.now.next_year.end_of_year
  BusinessTime::Config.beginning_of_workday = "00:00:00 am"
  BusinessTime::Config.end_of_workday = "11:59:59 pm"
  HolidayJp.between(start_date, end_date).each{|h| BusinessTime::Config.holidays << h.date }
end
