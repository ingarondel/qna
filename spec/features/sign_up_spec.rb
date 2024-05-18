require 'rails_helper'

feature 'User can sign up', %q{
	In order to ask, create and answer questions
	As an unauthenticated user
	I'd like to be able to sign in
} do  

	given(:user) {create(:user)}
	background do
	 	visit new_user_registration_path 
	 	fill_in 'Password', with: user.password
	 	fill_in 'Password confirmation', with: user.password
	end

	scenario 'User try to register' do  
	 	fill_in 'Email', with: 'newuser@mail.ru'	 
		click_on 'Sign up'

		expect(page).to have_content 'You have signed up successfully.'
	end
	scenario 'User try to register with errors' do 
		click_on 'Sign up'

		expect(page).to have_text("can't be blank",  normalize_ws: true)
	 	expect(page).to_not have_content 'You have signed up successfully.'
	end

end