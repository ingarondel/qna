require 'rails_helper'

feature 'User can sign out', %q{
	I'd like to be able to sign out
} do  

	given(:user) {create(:user)}
	background { visit new_user_session_path }

	scenario 'Registered user tries to sign out' do  
		sign_in(user)
		click_on 'Log out'

		expect(page).to have_content 'Signed out successfully.'
	end
	scenario 'Unregistered user tries to sign out' do 
	  visit questions_path

	  expect(page).to_not have_content 'Log out'
	end
end