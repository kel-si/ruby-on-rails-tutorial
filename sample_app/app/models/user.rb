class User < ApplicationRecord
    # destroy associated microposts if user is destroyed
    has_many :microposts, dependent: :destroy
    has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
    has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
    has_many :following, through: :active_relationships, source: :followed
    # could omit source (has_many :followers, through: :passive_relationships)
    # due to Rails singularizing followers to look for FK follower_id
    has_many :followers, through: :passive_relationships, source: :follower

    # creates an accessible attribute (for storage in the cookies but not in the database)
    attr_accessor :remember_token, :activation_token, :reset_token

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
    def User.digest string
        cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost

        BCrypt::Password.create string, cost: cost
    end

    # returns a token (random string)
    def User.new_token
        SecureRandom.urlsafe_base64
    end

    # remembers a user in the db for use in persistent sessions
    # storing a hash digest of remember token
    def remember
        # here self refers to the user object instance
        self.remember_token = User.new_token
        # storing hash in the database under remember_digest (.digest is hash function)
        update_attribute(:remember_digest, User.digest(remember_token))
        remember_digest
    end

    # returns a session token to prevent session hijacking
    # reuse remember digest for convenience
    def session_token
        remember_digest || remember
    end

    # generalized authenticated method
    def authenticated? attribute, token
        digest = self.send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    # forgets a user
    def forget
        # clear digest in the db
        update_attribute(:remember_digest, nil)
    end

    # activates an account
    def activate
        update_columns(activated: true, activated_at: Time.zone.now)
    end

    def send_activation_email
        UserMailer.account_activation(self).deliver_now
    end

    # sets the password reset attribute
    def create_reset_digest
        self.reset_token = User.new_token
        update_columns(reset_digest: User.digest(reset_token) , reset_sent_at: Time.zone.now)
    end

    def send_password_reset_email
        UserMailer.password_reset(self).deliver_now
    end

    def password_reset_expired?
        reset_sent_at < 2.hours.ago
    end

    def feed
        Micropost.where("user_id IN (?) OR user_id = ?", following_ids, id)
    end

    def follow(other_user)
        following << other_user unless self == other_user
    end

    def unfollow(other_user)
        following.delete(other_user)
    end

    def following?(other_user)
        following.include?(other_user)
    end

    private

        # converts email to all downcase 
        def downcase_email
            email.downcase!
        end

        def create_activation_digest
            self.activation_token = User.new_token
            self.activation_digest = User.digest(activation_token)
        end
end
