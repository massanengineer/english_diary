module DiaryEntriesHelper
  def calendar_weeks(year, month)
    first_day = Date.new(year, month, 1)
    last_day = first_day.end_of_month

    leading_blanks = Array.new(first_day.wday, nil)
    days = (first_day..last_day).to_a

    weeks = (leading_blanks + days).each_slice(7).to_a
    weeks.last.concat(Array.new(7 - weeks.last.size, nil)) if weeks.last.size < 7
    weeks
  end
end
