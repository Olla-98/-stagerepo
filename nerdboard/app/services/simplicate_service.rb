class SimplicateService
  def initialize
    @api_key = ENV["SIMPLICATE_API_KEY"]
  end

  def organizations
    if @api_key.present?
      raise NotImplementedError, "Echte Simplicate-aanroep bouwen we zodra de key er is"
    else
      fake_organizations
    end
  end

  private

  def fake_organizations
    [
      { "id" => "999", "name" => "Testklant BV" },
      { "id" => "111", "name" => "Andere Klant BV" }
    ]
  end
end
