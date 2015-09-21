require 'spec_helper'
require 'rails_helper'

feature "the signup process" do
  scenario "has a new user page" do
    visit new_user_url
    expect(current_url).to eq(new_user_url)
  end

  feature "signing up a user" do
    scenario "shows username on the homepage after signup" do
      user = build(:user)     # Need to create user factory
      visit new_user_url
      fill_in "Username", with: user.username
      fill_in "Password", with: user.password
      click_button "Sign Up"

      expect(page).to have_content("#{user.username}")
    end
  end

end

feature "logging in" do
  scenario "shows username on the homepage after login" do
    user = create(:user)
    visit new_session_url
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Sign In"

    expect(current_url).to eq(user_url(user))
    expect(page).to have_content("#{user.username}")
  end

end

feature "logging out" do
  scenario "begins with logged out state" do
    visit new_session_url

    expect(page).to have_content("Sign In")
  end

  scenario "doesn't show username on the homepage after logout" do
    user = create(:user)
    visit new_session_url
    fill_in "Username", with: user.username
    fill_in "Password", with: user.password
    click_button "Sign In"
    click_on "Sign Out"

    expect(page).to_not have_content("#{user.username}")
  end
end
