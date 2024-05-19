require 'rails_helper'

feature 'User can browse question with answers' do
  let!(:user) { create(:user) }
  let!(:question) { create(:question, user: user) }
  let!(:answers) { create_list(:answer, 2, question: question, user: user) }

  scenario 'User can visit page with all questions' do
    visit question_path(question)

    expect(page).to have_content('Answer', count: 2)
  end
end