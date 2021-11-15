RSpec.shared_examples "logged in user for edit,update" do |action|
  context "logged in" do
    it "stored user_id in session" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      if action.eql? :update
        patch user_path(id: user.id), params: {user: user.attributes}
      else
        get edit_user_path(id: user.id)
      end
      expect(session[:user_id]).to eq user.id
    end
  end

  context "not logged in" do
    before do
      if action.eql? :update
        patch user_path(id: user.id)
      else
        get edit_user_path(id: user.id)
      end
    end
    it "display flash message" do
      expect(flash[:danger]).to eq I18n.t("flash.login.warning_user")
    end
    it "redirect to login URL" do
      should redirect_to(login_path)
    end
  end
end

RSpec.shared_examples "load user for show,edit,update" do |action|
  context "load user successed" do
    before do
      if action.eql? :show
        get user_path(id: user.id)
      else
        post login_path,
          params: {session: {email: user.email, password: user.password}}
        if action.eql? :update
          patch user_path(id: user.id), params: {user: user.attributes}
        else
          get edit_user_path(id: user.id)
        end
      end
    end
    it "return user" do
      assert_equal user, assigns(:user)
    end
  end

  context "load user failed" do
    before do
      if action.eql? :show
        get user_path(id: 0)
      else
        post login_path,
          params: {session: {email: user.email, password: user.password}}
        if action.eql? :update
          patch user_path(id: 0), params: {user: user.attributes}
        else
          get edit_user_path(id: 0)
        end
      end
    end
    it "display flash message" do
      expect(flash[:danger]).to eq I18n.t("flash.show.user.failed")
    end
    it "redirect to root URL" do
      should redirect_to(root_url)
    end
  end
end

RSpec.shared_examples "authorize right owner for edit,update" do |action|
  context "correct user" do
    it "has current user equal owner user" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      if action.eql? :update
        patch user_path(id: user.id), params: {user: user.attributes}
      else
        get edit_user_path(id: user.id)
      end
      expect(session[:user_id]).to eq assigns(:user).id
    end
  end

  context "not correct user" do
    before do
      user_2 = create :user
      post login_path,
        params: {session: {email: user_2.email, password: user_2.password}}
      if action.eql? :update
        patch user_path(id: user.id)
      else
        get edit_user_path(id: user.id)
      end
    end
    it "display flash message" do
      expect(flash[:danger]).to eq I18n.t("flash.edit.wrong_user")
    end
    it "redirect to root URL" do
      should redirect_to(root_url)
    end
  end
end

RSpec.shared_examples "validate user for create,update" do |action|
  context "user's valid" do
    before do
      if action.eql? :create
        post users_path, params: {user: user_attributes}
      else
        post login_path,
          params: {session: {email: user.email, password: user.password}}
        patch user_path(id: user.id), params: {user: user.attributes}
      end
    end
    if action.eql? :create
      it "login" do
        expect(session[:user_id]).to eq assigns(:user).id
      end
    end
    it "display flash message" do
      expect(flash[:success]).to eq I18n.t("flash.#{action}.successed")
    end
    it "redirect to user's page" do
      should redirect_to(assigns(:user))
    end
  end

  context "user isn't valid" do
    before do
      if action.eql? :create
        user_attributes[:name] = ""
        post users_path, params: {user: user_attributes}
      else
        user[:name] = ""
        post login_path,
          params: {session: {email: user.email, password: user.password}}
        patch user_path(id: user.id), params: {user: user.attributes}
      end
    end

    it "display flash message" do
      expect(flash.now[:danger]).to eq I18n.t("flash.#{action}.failed")
    end
    if action.eql? :create
      it "render new" do
        expect(response).to render_template :new
      end
    else
      it "render edit" do
        expect(response).to render_template :edit
      end
    end
    it "has right errors" do
      expect(assigns(:user).errors.full_messages).to eq [I18n.t("activerecord.attributes.user.name") + " " +
        I18n.t("activerecord.errors.models.user.blank")]
    end
  end
end
