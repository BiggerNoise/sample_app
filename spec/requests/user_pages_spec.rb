require 'spec_helper'

describe "UserPages" do
  subject {page}

  shared_examples_for "logged in user page" do
    it { should have_link('Profile', href: user_path(user)) }
    it { should have_link('Settings', href: edit_user_path(user)) }
    it { should have_link('Sign out', href: signout_path) }
    it { should_not have_link('Sign in') }
  end


  describe "signup page" do
    before { visit signup_path}

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector 'title', text: full_title('Sign up')}

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: 'Sign up') }
        it { should have_selector('#error_explanation') }
        it { should have_error_message 'The form contains' }

        (['Name', 'Email', 'Password', 'Password confirmation']).each do |field_name|
          it { should have_selector('#error_explanation ul li', text: field_name) }
        end
      end

    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by_email('user@example.com') }

        it { should have_selector('h1',    text: user.name) }
        it { should have_selector('title', text: user.name) }
        it { should have_success_message 'Welcome' }
        it { should have_link('Sign out') }


      end

    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      visit user_path(user)
    end

    it { should have_selector('h1',    text: user.name) }
    it { should have_selector('title', text: user.name) }
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_selector('h1',    text: "Update your Profile") }
      it { should have_selector('title', text: "Edit User") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_error_message }
    end

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_selector('title', text: new_name) }
      it { should_not have_error_message }
      it { should have_success_message 'Profile Updated' }

      it_should_behave_like "logged in user page"

      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end

  end

  describe "index" do
    before do
      sign_in FactoryGirl.create(:user)
      FactoryGirl.create(:user, name: "Bob", email: "bob@example.com")
      FactoryGirl.create(:user, name: "Ben", email: "ben@example.com")
      visit users_path
    end

    it { should have_selector('title', text: 'All Users') }
    it { should have_selector('h1',    text: 'All Users') }

    it "should list each user" do
      User.all.each do |user|
        page.should have_selector('li', text: user.name)
      end
    end
  end
end
