class ProjectsController < ApplicationController
    before_action :authenticate_request
    
    def index
        if @current_user.simplicate_organization_id.blank?
            render json: {error: "Je account is nog niet gekoppeld aan een Simplicate organisatie. Neem contact op met de beheerder."}, status: :forbidden
            return
        end

        projects = SimplicateService.new.projects_for(@current_user.simplicate_organization_id)
        projects = projects.map do |project|
            {
                id: project.fetch("id"),
                name: project.fetch("name"),
                budget: project.fetch("budget"),
                recorded: project.fetch("geregistreerde_uren"),
                remaining: project.fetch("resterende_uren")
            }
        end
        render json: projects, status: :ok
    end
end
