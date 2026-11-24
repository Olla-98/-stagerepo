class ProjectsController < ApplicationController
<<<<<<< Updated upstream
  before_action :authenticate_request

  def index
    organization_id = SimplicateService.organization_id
    projects = SimplicateService.new.projects_for(organization_id)
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
=======
    # before_action :authenticate_request
    
    def index
        # if @current_user.simplicate_organization_id.blank?
        #     render json: {error: "Je account is nog niet gekoppeld aan een Simplicate organisatie. Neem contact op met de beheerder."}, status: :forbidden
        #     return
        # end
        service = SimplicateService.new(subdomain: "nerds", api_key: ENV.fetch("SIMPLIFICATE_API_KEY"), api_secret: ENV.fetch("SIMPLIFICATE_API_SECRET"))
        project = service.project_for("project:096b2fc2bc5133784c13c77ab857ae53")
        render json: project, status: :ok
    end

    def details
        service = SimplicateService.new(subdomain: "nerds", api_key: ENV.fetch("SIMPLIFICATE_API_KEY"), api_secret: ENV.fetch("SIMPLIFICATE_API_SECRET"))
        # project = service.project_for(PROJECT_ID)
        render json: project, status: :ok
    end
>>>>>>> Stashed changes
end
