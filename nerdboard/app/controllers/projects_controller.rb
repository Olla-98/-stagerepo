class ProjectsController < ApplicationController
    before_action :authenticate_request
    
    def index
        if @current_user.simplicate_organization_id.blank?
            render json: {error: "Je account is nog niet gekoppeld aan een Simplicate organisatie. Neem contact op met de beheerder."}, status: :forbidden
            return
        end

        projects = SimplicateService.new.projects_for(@current_user.simplicate_organization_id)
        render json: projects, status: :ok
    end
end
