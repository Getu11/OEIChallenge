class Course
  attr_reader :name, :type

  def initialize(name:, type:)
    raise ArgumentError, "Invalid course attributes" if name.blank? || type.blank?
    
    @name = name
    @type = type
  end
end
