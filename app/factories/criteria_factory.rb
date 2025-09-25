Dir["#{__dir__}/criteria/*.rb"].each { |file| require_relative file }

class CriteriaFactory
  def self.build(criteria_params)
    criteria_params.map do |c|
      case c
      when "closest" then ClosestCriteria.new
      when "latest" then LatestCriteria.new
      when /^type-(.+)$/ then TypeNameCriteria.new($1)
      when /^school-(.+)$/ then SchoolNameCriteria.new($1)
      else
        raise ArgumentError, "Unknown criteria: #{c}"
      end
    end
  end
end