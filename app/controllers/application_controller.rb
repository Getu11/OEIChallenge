class ApplicationController < ActionController::API

  before_action :validate_json

  rescue_from StandardError, with: :handle_standard_error
  rescue_from ArgumentError, with: :handle_argument_error
  rescue_from ActionController::ParameterMissing, with: :handle_missing_params

  def radar
    editions = EditionBuilder.build(check_params[:editions])
    criteria = CriteriaFactory.build(check_params[:criteria])
    selector = CourseSelector.new(criteria)
    result = selector.select_courses(editions)

    render json: result.map { |e| { date: e.date, courses: e.courses.map(&:name) } }
  end

  private

  def validate_json
    unless request.content_type == "application/json"
      render json: { error: "Content-Type must be application/json" }, status: :bad_request
    end

    JSON.parse(request.body.read)
  rescue JSON::ParserError
    render json: { error: "Invalid JSON" }, status: :bad_request
  end

  def check_params
    params.require(:criteria)
    params.require(:editions)

    params.permit(
      criteria: [],
      editions: [
        :date,
        { courses: [:name, :type] }
      ]
    )
  end

  def handle_argument_error(exception)
    render json: { error: exception.message }, status: :bad_request
  end

  def handle_standard_error(exception)
    render json: { error: exception.message }, status: :internal_server_error
  end

  def handle_missing_params(exception)
    render json: { error: "Missing required field: #{exception.param}" }, status: :bad_request
  end
end
