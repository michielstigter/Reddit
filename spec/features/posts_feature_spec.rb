require 'rails_helper'

describe 'posts' do
	context 'when logged in' do
		before do
			visit 'users/sign_up'
			fill_in 'user[email]', with: "a@a.com"
			fill_in 'user[password]', with: "12345678"
			fill_in 'user[password_confirmation]', with: "12345678"
			click_button 'Sign up'
		end

		context 'no posts added yet' do
			it 'should display a link to add a post' do
				visit '/posts'
				expect(page).to have_content 'No posts yet'
				expect(page).to have_link 'Add a post'
			end
		end

		context 'with posts' do
			before do
				post = Post.create(title: 'Hello World!', url: 'www.google.com')
			end

			it 'links to a certain website' do
				visit '/posts'
				expect(find_link('Hello World!')[:href]).to eq 'http://www.google.com'

			end

			it 'displays a list of all posts' do
				visit '/posts'
				expect(page).to have_content 'Hello World!'
			end


		end

		context 'adding posts' do
			it 'allows a user to post a post' do
				visit '/posts'
				click_link 'Add a post'
				expect(current_path).to eq new_post_path
				fill_in 'Title', with: 'A brand new post'
				fill_in 'Url', with: 'www.google.com'
				click_button 'Create Post'
				expect(current_path).to eq '/posts'
				expect(page).to have_content 'A brand new post'
			end
		end

		context 'upvoting' do
			before do
				post = Post.create(title: 'Hello World!', url: 'www.google.com')
			end

			it 'allows a user to upvote a post' do
				visit '/posts'
				click_button 'upvote'
				expect(post.score).to eq 1
			end
		end

		context 'comments' do
			before do
				@post = Post.create(title: 'Hello World!', url: 'www.google.com')
			end
			it 'should contain a link to the comment page' do
				visit '/posts'
				puts @post
				click_link 'comments'
				id = @post.id
				expect(current_path).to eq post_path(id)
				expect(page).to have_content "Hello World!"
			end
		end
	end
	context 'when not logged in' do

		before do
			Post.create(title: 'Hello World!', url: 'www.google.com')
		end

		it 'displays a list of all posts' do
			visit '/posts'
			expect(page).to have_content 'Hello World!'
		end
	end
end
