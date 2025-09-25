class Edition
  attr_reader :date, :courses
  
  def initialize(date:, courses:)
    raise ArgumentError, "Invalid course attributes" if date.blank? || courses.blank?
    
    @date = Date.parse(date)
    @courses = courses
  end
end