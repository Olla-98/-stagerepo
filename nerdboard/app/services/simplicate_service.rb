class SimplicateService
  def initialize
    @api_key = ENV["SIMPLICATE_API_KEY"]
  end

  def organizations
    if @api_key.present?
      raise NotImplementedError, "Dit is geen echte implementatie van de Simplicate API. Nog geen echte API-key aanwezig."
    else
     fake_organizations
    end
  end

  def projects_for(organization_id)
    if @api_key.present?
      raise NotImplementedError, "Dit is geen echte implementatie van de Simplicate API. Nog geen echte API-key aanwezig."
    else
      fake_projects.select { |project| project["organization_id"] == organization_id }
    end
  end
    
  private

  def fake_organizations
    [
      { "id" => 999, "name" => "Testklant BV" },
      { "id" => 111, "name" => "Andere Klant BV" }
    ]
  end

  def fake_projects
    [
      { "id" => "1", "name" => "Website ontwikkeling en onderhoud", "organization_id" => 999, "budget" => 1000, "geregistreerde_uren" => 10, "resterende_uren" => 20 },
      { "id" => "2", "name" => "Webshop Sima", "organization_id" => 999, "budget" => 5000, "geregistreerde_uren" => 20, "resterende_uren" => 30 },
      { "id" => "3", "name" => "Project 3", "organization_id" => 111, "budget" => 2000, "geregistreerde_uren" => 5, "resterende_uren" => 15 }
    ]
  end
end
