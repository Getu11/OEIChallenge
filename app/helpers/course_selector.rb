class CourseSelector
  def initialize(criteria)
    @criteria = criteria
  end

  def select_courses(editions)
    # type criteria filter first, then date criteria
    date_criteria, type_criteria = @criteria.partition { |c| c.criteria_type == "date" }

    result = type_criteria.reduce(editions) { |editions, criteria| criteria.apply(editions) }
    result = date_criteria.reduce(result) { |editions, criteria| criteria.apply(editions) }

    result
  end
end