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
    it_should_behave_like "load user for show,edit,update", :show
  end

  describe "POST #create" do
    let!(:user_attributes) do
      {name: Faker::Name.name_with_middle,
        email: Faker::Internet.email.downcase,
        password: "foobar",
        password_confirmation: "foobar"}
    end
    it_should_behave_like "validate user for create,update", :create
  end

  describe "GET #edit" do
    it_should_behave_like "logged in user for edit,update", :edit
    it_should_behave_like "load user for show,edit,update", :edit
    it_should_behave_like "authorize right owner for edit,update", :edit
  end

  describe "GET #update" do
    it_should_behave_like "logged in user for edit,update", :update
    it_should_behave_like "load user for show,edit,update", :update
    it_should_behave_like "authorize right owner for edit,update", :update
    it_should_behave_like "validate user for create,update", :update
  end
end
