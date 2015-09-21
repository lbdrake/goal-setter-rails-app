require 'spec_helper'
require 'rails_helper'

feature "creating a new goal" do

  scenario "user can create goal from user page and it reloads the page" do
    user = create(:user)
    login_user(user)
    fill_in "Goal", with: "Pass the Assessment"
    choose "Public"
    click_on "Create a Goal"

    expect(current_url).to eq(user_url(user))
  end

  scenario "public and private goals appear on signed in user's page" do
    user = create(:user)
    login_user(user)
    fill_in "Goal", with: "Pass the Assessment"
    choose "Public"
    click_on "Create a Goal"

    fill_in "Goal", with: "Get a Job"
    choose "Private"
    click_on "Create a Goal"

    expect(page).to have_content("Get a Job")
    expect(page).to have_content("Pass the Assessment")
  end

  scenario "only public (not private) goals appear to other logged in users" do
    user = create(:user)
    login_user(user)

    create_private_goal
    create_public_goal

    click_button "Sign Out"

    user2 = create(:user)
    login_user(user2)

    click_on "All Public Goals"

    expect(page).to have_content("Pass the Assessment")
    expect(page).to_not have_content("Get a Job")
  end

end

feature "updating an existing goal" do
  scenario "clicking on update redirects to Goal Update page" do
    user = create(:user)
    login_user(user)
    create_private_goal

    click_on "edit"

    expect(page).to have_content("Edit Goal")
  end

  scenario "updated goal text appears on users page" do
    user = create(:user)
    login_user(user)
    create_private_goal

    click_on "edit"
    fill_in "Goal", with: "Get a really good job! NOW!"
    choose "Public"
    click_button "Save"

    expect(page).to have_content("Get a really good job! NOW!")
    expect(page).to have_content("Public")
  end

  scenario "doesn't let you update other users' goals" do
    user = create(:user)
    login_user(user)

    create_private_goal
    create_public_goal

    click_button "Sign Out"

    user2 = create(:user)
    login_user(user2)
    visit edit_goal_url(user.goals.first)

    expect(current_url).to eq(user_url(user2))
  end
end

feature "deleting a goal" do
  scenario "redirects to user's page after clicking Delete button" do
    user = create(:user)
    login_user(user)
    create_private_goal
    click_button "delete"

    expect(current_url).to eq(user_url(user))
    expect(page).to_not have_content("Get a Job")
  end

  scenario "doesn't let you delete other users' goals" do
    user = create(:user)
    login_user(user)
    create_private_goal
    create_public_goal
    click_button "Sign Out"

    user2 = create(:user)
    login_user(user2)

    visit user_url(user)

    expect(page).not_to have_content("delete")
  end
end
