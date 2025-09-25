class EditionBuilder
  def self.build(edition_params)
    edition_params.map do |edition|
      Edition.new(
        date: edition[:date],
        courses: edition[:courses].map do |course| 
          Course.new(name: course[:name], type: course[:type]) 
        end
      )
    end
  end
end