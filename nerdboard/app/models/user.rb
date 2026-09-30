class User < ApplicationRecord
    has_secure_password

    before_validation :generate_api_token, on: :create

    validates :email, presence: true, uniqueness: true
    validates :api_token, presence: true, uniqueness: true

    private
    def generate_api_token
        self.api_token ||= SecureRandom.hex(32) # Generates a random 32-character hexadecimal string
    end
end
