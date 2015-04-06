require 'rails_helper'

RSpec.describe "user visit traveler page spec" do
  let!(:user) { create(:user) }

  it "can view traveler page" do
    sign_in(:user)
    expect(page).to have_content("Traveler Page: #{user.username}")
  end

  def sign_in(user)
    visit root_path
    fill_in("session[username]", with: "Sally")
    fill_in("session[password]", with: "password")
    first(:css, "#small_submit_button").click
  end
end
