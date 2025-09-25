class LatestCriteria
  attr_reader :criteria_type

  def initialize
    @criteria_type = "date"
  end

  def apply(editions)
    return [] if editions.empty?

    [editions.select{|x| x.date >= Date.today}.max_by(&:date)]
  end
end