require "spec_helper"

feature "Homepage" do
  scenario "Has register button" do
    visit "/"
    expect(page).to have_button("Register")
  end
end

feature "Register Page" do
  scenario "checking the page" do
    visit "/"
    click_link "Register"
    expect(page).to have_content("Username")
    expect(page).to have_content("Password")
    expect(page).to have_content("Confirm Password")
    expect(page).to have_button("register")
  end
end

feature "Create Account" do
  scenario "creating an account" do
    visit "/registration"
    fill_in "username", :with => "Alex"
    fill_in "password", :with => "pass1"
    fill_in "password_confirmation", :with => "pass1"
    click_button "register"
  end
  scenario "login to account" do
    visit "/"
    fill_in "username", :with => "Alex"
    fill_in "password", :with => "pass1"
    click_button "Login"
    expect(page).to have_content("Welcome User")
  end
end

feature "Login to account" do
  scenario "has a username typed in" do
    skip
  end
  # click_button "register"
  # expect(page).to have_content "Hi"
end

describe UserDatabase do
  let(:user_database) { UserDatabase.new }

  describe "#insert" do
    it "returns the object if it succeeds" do
      user_as_hash = {:username => "jetaggart", :password => "password"}

      result = user_database.insert(user_as_hash)

      expect(result).to include({:username => "jetaggart", :password => "password"})
    end

    it "gives the user an id" do
      user_as_hash = {:username => "jetaggart", :password => "password"}

      user = user_database.insert(user_as_hash)

      expect(user[:id]).to eq(1)
    end

    it "offsets the id by how many users exist" do
      user_database.insert({:username => "jetaggart", :password => "some password"})
      second_user = user_database.insert(:username => "another_name", :password => "some other password")

      expect(second_user[:id]).to eq(2)
    end

    context "validations" do
      it "requires a username" do
        expect {
          user_database.insert(:password => "password")
        }.to raise_error(ArgumentError, "username required")
      end

      it "requires a password" do
        expect {
          user_database.insert(:username => "username")
        }.to raise_error(ArgumentError, "password required")
      end

      it "shows many validations" do
        expect {
          user_database.insert({})
        }.to raise_error(ArgumentError, "username, password required")
      end
    end
  end

  describe "#find" do
    it "finds the user by the id" do
      user_database.insert(:username => "first", :password => "password")
      user_database.insert(:username => "jetaggart", :password => "password")
      user_database.insert(:username => "last", :password => "password")

      found_user = user_database.find(2)

      expect(found_user).to include(:username => "jetaggart", :password => "password")

      found_user = user_database.find(3)

      expect(found_user).to include(:username => "last", :password => "password")
    end

    it "raises an error if no user can be found" do
      expect {
        user_database.find(1)
      }.to raise_error(UserDatabase::UserNotFoundError)
    end
  end

  describe "#delete" do
    it "deletes at the correct id" do
      user_database.insert(:username => "first", :password => "password")
      user_database.delete(1)

      expect(user_database.all).to eq([])
    end

    it "raises an error the an incorrect id is given" do
      expect {
        user_database.delete(1)
      }.to raise_error(UserDatabase::UserNotFoundError)
    end
  end
end
