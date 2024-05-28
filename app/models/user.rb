class User < ApplicationRecord
  has_many :questions
  has_many :answers
  has_many :authorizations
  
   devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]

    def self.find_for_oauth(auth)
      Services::FindForOauth.new(auth).call
      
    end

    def is_author?(resource)
      self.id == resource.user_id
    end

    def create_authorization(auth)
       self.user.authorizations.create(provider: auth.provider, uid: auth.uid)
    end
end
