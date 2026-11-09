class User < ApplicationRecord
    API_TOKEN_TTL = 1.hour

    has_secure_password

    before_validation :issue_api_token, on: :create

    validates :name, presence: true
    validates :email,
      presence: true,
      uniqueness: { case_sensitive: false },
      format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :api_token, presence: true, uniqueness: true
    validates :password, length: { minimum: 8 }, allow_nil: true
    validates :simplicate_organization_id, presence: true

    def api_token_valid?
      api_token.present? && api_token_expires_at&.future?
    end

    def issue_api_token!
      update!(api_token: SecureRandom.hex(32), api_token_expires_at: API_TOKEN_TTL.from_now)
    end

    def revoke_api_token!
      update!(api_token: SecureRandom.hex(32), api_token_expires_at: nil)
    end

    private

    def issue_api_token
      self.api_token ||= SecureRandom.hex(32)
      self.api_token_expires_at ||= API_TOKEN_TTL.from_now
    end
end
