namespace :simplicate do
  desc "List Simplicate organizations and their IDs"
  task organizations: :environment do
    service = SimplicateService.new
    subdomain = ENV["SIMPLICATE_SUBDOMAIN"]
    puts "Simplicate API testen: https://#{subdomain}.simplicate.nl/api/v2/crm/organization"

    organizations = service.organizations
    puts "Verbinding gelukt. Organisaties die deze API-gebruiker mag zien:"
    organizations.each do |organization|
      puts "#{organization.fetch("id")}\t#{organization.fetch("name")}"
    end

    puts "Geen organisaties gevonden. Controleer de rechten van de API-gebruiker." if organizations.empty?
  rescue SimplicateService::ConfigurationError => error
    abort "Configuratie ontbreekt of is ongeldig: #{error.message}"
  rescue SimplicateService::RequestError => error
    hint = case error.message
    when /HTTP-status 401/
      " Controleer of API-key en secret bij elkaar horen en of het token actief is."
    when /HTTP-status 403/
      " De API-gebruiker heeft geen toegang tot organisaties; controleer de rechten in Simplicate."
    when /HTTP-status 404/
      " Controleer of SIMPLICATE_SUBDOMAIN de juiste accountnaam bevat."
    when /bereikbaar/
      " Controleer internet, het subdomein en dat de API-host .simplicate.nl gebruikt."
    else
      ""
    end
    abort "Simplicate API-test mislukt: #{error.message}#{hint}"
  end
end
