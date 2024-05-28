require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many :questions }
  it { should have_many :answers }
  it { should have_many(:authorizations).dependent(:destroy)}

  it { should validate_presence_of :email }
  it { should validate_presence_of :password }

  describe '.find_for_oauth' do  
    let!(:user) { create(:user)}
    let(:auth){ OmniAuth::AuthHash.new(provider: 'facebook', uid: '123456')}
    let(:service) {double('Services::FindForOauth')}

    it 'calls Services::FindForOauth' do  
      expect(Services::FindForOauth).to receive(:new).with(auth).and_return(service)
      expect(service).to receive(:call)
      User.find_for_oauth(auth)
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