class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :authorizations
  
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

    def self.find_for_oauth(auth)
      authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
      return authorization.user if authorization

      email = auth.info[:email]
      user = User.where(email: email).first
      if user  
        user.create_authorization(auth)
      else
        passwowrd = Devise.friendly_token[0, 20]
        user = User.create!(email: email, passwowrd: password, passwowrd_confirmation: password)
        user.create_authorization(auth)
      end
      user
    end

    def is_author?(resource)
      self.id == resource.user_id
    end

    def create_authorization(auth)
       self.user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
end
