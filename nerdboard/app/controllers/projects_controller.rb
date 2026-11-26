class ProjectsController < ApplicationController
  before_action :authenticate_request

  def index
    assigned_ids = current_user.project_assignments.pluck(:simplicate_project_id)
    return render json: [], status: :ok if assigned_ids.empty?

    projects = SimplicateService.new.projects_for
      .select { |project| assigned_ids.include?(project.fetch("id")) }
    render json: projects, status: :ok
  rescue SimplicateService::ConfigurationError => error
    Rails.logger.error("Simplicate configuration error: #{error.message}")
    render json: { error: "De Simplicate-koppeling is nog niet volledig ingesteld." }, status: :service_unavailable
  rescue SimplicateService::RequestError => error
    Rails.logger.error("Simplicate request error: #{error.message}")
    render json: { error: "Projectgegevens konden niet uit Simplicate worden opgehaald." }, status: :bad_gateway
  rescue ArgumentError, TypeError => error
    Rails.logger.error("Invalid Simplicate project data: #{error.class}")
    render json: { error: "Simplicate gaf ongeldige projectgegevens terug." }, status: :bad_gateway
  end
end
