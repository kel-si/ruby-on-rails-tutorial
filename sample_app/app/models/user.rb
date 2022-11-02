class User < ApplicationRecord
    # creates an accessible attribute (for storage in the cookies but not in the database)
    attr_accessor :remember_token, :activation_token

    before_save :downcase_email
    before_create :create_activation_digest

    validates :name, presence: true, length: { maximum: 50 }
    VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
    validates :email, presence: true, length: { maximum: 255 }, format: {with: VALID_EMAIL_REGEX}, uniqueness: true

    # adds ability to save hashed password to db
    # pair of virtual attritbutes (password and password_confirmation) including presence validation upon object creation as well as validation for matching
    # authenticate method that returns user when password is correct (else returns false)
    has_secure_password
    validates :password, presence: true, length: { minimum: 6 }, allow_nil: true


    # returns the hash digest of the given string
    # attaching digest to User class itself makes it a class method
    # self here refers to the User class
    # instead of using self in the method definitions, could use:
    # class << self to wrap digest and new_token methods
    def self.digest string
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

        BCrypt::Password.create string, cost: cost
    end

    # returns a token (random string)
    def self.new_token
        SecureRandom.urlsafe_base64
    end

    # remembers a user in the db for use in persistent sessions
    # storing a hash digest of remember token
    def remember
        # here self refers to the user object instance
        self.remember_token = User.new_token
        # storing hash in the database under remember_digest
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    # returns a session token to prevent session hijacking
    # reuse remember digest for convenience
    def session_token
        remember_digest || remember
    end

    # returns true if the given token (saved in browser) matches the digest
    def authenticated? remember_token
        return false if remember_digest.nil?
        BCrypt::Password.new(remember_digest).is_password?(remember_token)
    end

    # forgets a user
    def forget
        # clear digest in the db
        update_attribute(:remember_digest, nil)
    end

    private

        # converts email to all downcase 
        def downcase_email
            self.email = email.downcase
        end

        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
