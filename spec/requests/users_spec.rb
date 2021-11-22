require "rails_helper"
require "shared/share_examples"

RSpec.describe "Users", type: :request do
  let!(:user){create :user}

  describe "GET #new" do
    it "create new record" do
      get new_user_path
      expect(assigns(:user).new_record?).to eq true
    end
  end

  describe "GET #show" do
    it_should_behave_like "load object in model for action",:user, :show
  end

  describe "POST #create" do
    let!(:user_attributes) do
      {name: Faker::Name.name_with_middle,
        email: Faker::Internet.email.downcase,
        password: "foobar",
        password_confirmation: "foobar"}
    end
    it_should_behave_like "validate object", :user, :create
  end

  describe "GET #edit" do
    it_should_behave_like "logged in user", :user, :edit
    it_should_behave_like "load object in model for action",:user, :edit
    it_should_behave_like "authorize access", :user, :edit
  end

  describe "PATCH #update" do
    it_should_behave_like "logged in user", :user, :update
    it_should_behave_like "load object in model for action",:user, :update
    it_should_behave_like "authorize access", :user, :update
    it_should_behave_like "validate object", :user, :update
  end
end
