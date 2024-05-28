require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do  
    let!(:user) { create(:user)}
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456')}

    context 'user already has authorization' do  
      it 'returns the user' do  
        user.authorizations.create(provider: 'facebook', uid: '123456')
        expect(User.find_for_oauth(auth)).to eq user
      end
    end
    context 'user has not authorization' do  
      context 'user already exists' do  
        let(:auth){OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {user.email })}
        it 'does not create new user' do  
          expect { User.find_for_oauth(auth)}.to_not change(User, :count)
        end
        it 'creates authorization for user' do  
           expect { User.find_for_oauth(auth)}.to change(user.authorizations, :count).by(1)
        end
        it 'creates authorization with provider and uid' do  
          authorization = User.find_for_oauth(auth).authorizations.first

          expect(authorization.provider).to eq auth.provider
          expect(authorization.uid).to eq auth.uid
        end
        it 'returns the user' do 
          expect(User.find_for_oauth(auth)).to eq user
        end
        context 'user does not exist' do  
          let(:auth) {OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456', info: {email: 'new@user.com'}) }

          it 'creates new user' do  
            expect { User.find_for_oauth(auth)}.to change(User, :count).by(1)
          end 
          it 'returns new user' do  
            expect(User.find_for_oauth(auth)).to be_a(User)
          end
          it 'fills user email' do  
            user = User.find_for_oauth(auth)
            expect(user.email).to eq auth.email
          end
          it 'creates authorization for user' do 
            user = User.find_for_oauth(auth)
            expect(user.authorizations).to_not be_empty
          end
          it 'creates authorization with provider and uid' do  
            authorization = User.find_for_oauth(auth).authorizations.first

            expect(authorization.provider).to eq auth.provider
            expect(authorization.uid).to eq auth.uid
          end
        end
      end
    end
  end
end

describe 'instance methods is_author?' do

  describe '#is_author? will return the true ' do

    context 'user is author' do
      let(:user){ create(:user) }
      let(:question){ create(:question, user_id: user.id) }
      let(:answer){ create(:answer, user_id: user.id) }

      it 'returns true for answer' do
        expect(user.is_author?(answer)).to be true
      end

      it 'returns true for question' do
        expect(user.is_author?(question)).to be true
      end
    end

    context 'user is not author' do
      let(:user){ create(:user) }
      let(:question){ create(:question) }
      let(:answer){ create(:answer) }

      it 'returns false for answer' do
        expect(user.is_author?(answer)).to be false
      end

      it 'returns false for question' do
        expect(user.is_author?(question)).to be false
      end
    end
  end
end