class TypeNameCriteria
  attr_reader :criteria_type
  
  def initialize(type_name)
    @type_name = type_name
    @criteria_type = "type"
  end
  
  def apply(editions)
    return [] if editions.empty?

    editions.select{ |edition| edition.courses.flat_map(&:type).include?(@type_name) }.map do |edition|
      Edition.new(
        date: edition.date.to_s,
        courses: edition.courses.select{ |course| course.type == @type_name }
      )
    end
  end
end