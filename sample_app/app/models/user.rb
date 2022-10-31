class User < ApplicationRecord
    attr_accessor :remember_token

    # callback to downcase email before being saved to db
    # another option is { email.downcase! }
    before_save { self.email = email.downcase }

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

    # adds ability to save hashed password to db
    # pair of virtual attritbutes (password and password_confirmation) including presence validation upon object creation as well as validation for matching
    # authenticate method that returns user when password is correct (else returns false)
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }


    # returns the hash digest of the given string
    # attaching digest to User class itself makes it a class method
    def User.digest string
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

        BCrypt::Password.create string, cost: cost
    end

    # returns a random token
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    def remember
        self.remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end
end
