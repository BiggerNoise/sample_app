require 'spec_helper'

describe "StaticPages" do
  let(:base_title) {"Ruby on Rails Tutorial Sample App"}

  describe "Home page" do
    it "should have the h1 'Sample App'" do
      visit root_path
      page.should have_selector('h1', :text => 'Sample App')
    end

    it "should have the right title" do
      visit root_path
      page.should have_selector('title', :text => base_title)
    end

    it "should not have a custom page title" do
      visit root_path
      page.should_not have_selector('title', :text => '| Home')
    end

  end

  describe "Help page" do

    it "should have the h1 header 'Help'" do
      visit help_path
      page.should have_selector('h1', :text => 'Help')
    end

    it "should have the right title" do
      visit help_path
      page.should have_selector('title',
                                :text => "#{base_title} | Help")
    end
  end

  describe "About page" do
    it "should have the h1 header 'About Us'" do
      visit about_path
      page.should have_selector('h1', :text => 'About Us')
    end

    it "should have the right title" do
      visit about_path
      page.should have_selector('title',
                                :text => "#{base_title} | About")
    end

  end

  describe "Contact page" do
    it "should have the h1 header 'Contact Us'" do
      visit contact_path
      page.should have_selector('h1', :text => 'Contact Us')
    end

    it "should have the right title" do
      visit contact_path
      page.should have_selector('title',
                                :text => "#{base_title} | Contact")
    end

  end

end
