require 'rails_helper'

describe 'comments' do
	context 'when logged in' do
		before do
			visit 'users/sign_up'
			fill_in 'user[email]', with: "a@a.com"
			fill_in 'user[password]', with: "12345678"
			fill_in 'user[password_confirmation]', with: "12345678"
			click_button 'Sign up'
			@post = Post.create(title: 'Hello World!', url: 'www.google.com')
		end

		it 'allows a user to submit a comment' do
			visit '/posts'
			click_link 'comments'
			fill_in 'comment', with: "This is my oppinion."
			click_button 'Leave comment'
			expect(current_path).to eq post_comments_path(@post.id)
			expect(page).to have_content 'This is my oppinion.'
		end
	end
end
