class SchoolNameCriteria
  attr_reader :criteria_type

  def initialize(school_name)
    @school_name = school_name
    @criteria_type = "type"
  end

  def apply(editions)
    return [] if editions.empty?

    editions.select{ |edition| edition.courses.any? { |course| course.type == @school_name } }.map do |edition|
      Edition.new(
        date: edition.date.to_s,
        courses: edition.courses.select{ |course| course.type == @school_name }
      )
    end
  end
end