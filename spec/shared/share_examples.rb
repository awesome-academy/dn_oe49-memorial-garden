RSpec.shared_examples "logged in user" do |model, action|
  context "logged in" do
    it "stored user_id in session" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      case model
        when :user
          case action
            when :update
              patch user_path(id: user.id), params: {user: user.attributes}
            when :edit
              get edit_user_path(id: user.id)
            when :show
          end
        when :memorial
          case action
            when :index
              get user_memorials_path(user_id: memorial_1.user.id)
            when :new
              get new_memorial_path
            when :create
              post memorials_path, params: {memorial: {name: ""}}
            when :privacy_settings_for_get
              get privacy_settings_memorial_path(id: memorial_1.id)
            when :privacy_settings_for_patch
              patch privacy_settings_memorial_path(id: memorial_1.id)
            when :search_unshared_member
              get search_unshared_member_memorial_path(id: memorial_1.id)
          end
      end
      expect(session[:user_id]).to eq user.id
    end
  end

  context "not logged in" do
    before do
      case model
        when :user
          case action
            when :update
              patch user_path(id: user.id)
            when :edit
              get edit_user_path(id: user.id)
          end
        when :memorial
          case action
            when :index
              get user_memorials_path(user_id: memorial_1.user.id)
            when :new
              get new_memorial_path
            when :create
              post memorials_path(user_id: memorial_1.user.id)
            when :privacy_settings_for_get
              get privacy_settings_memorial_path(id: memorial_1.id)
            when :privacy_settings_for_patch
              patch privacy_settings_memorial_path(id: memorial_1.id)
            when :search_unshared_member
              get search_unshared_member_memorial_path(id: memorial_1.id)
          end
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

RSpec.shared_examples "load object in model for action" do |model, action|
  context "load user successed" do
    before do
      case model
        when :user
          @object = user
          @object_name = :user
          case action
            when :show
              get user_path(id: user.id)
            when :update
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              patch user_path(id: user.id), params: {user: user.attributes}
            when :edit
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              get edit_user_path(id: user.id)
          end
        when :memorial
          post login_path,
            params: {session: {email: user.email, password: user.password}}
          case action
            when :index
              @object = memorial_1.user
              @object_name = :user
              get user_memorials_path(user_id: memorial_1.user.id)
            when :show
              @object = memorial_1
              @object_name = :memorial
              get memorial_path(id: memorial_1.id)
            when :privacy_settings_for_get
              @object = memorial_1
              @object_name = :memorial
              get privacy_settings_memorial_path(id: memorial_1.id)
            when :privacy_settings_for_patch
              @object = memorial_1
              @object_name = :memorial
              patch privacy_settings_memorial_path(id: memorial_1.id)
            when :show_biography
              @object = memorial_1
              @object_name = :memorial
              get show_biography_memorial_path(id: memorial_1.id)
          end
      end
    end
    it "return #{@object_name}" do
      assert_equal @object, assigns(@object_name)
    end
  end

  context "load user failed" do
    before do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      case model
        when :user
          @object_name = :user
          case action
            when :show
              get user_path(id: 0)
            when :update
              patch user_path(id: 0), params: {user: user.attributes}
            when :edit
              get edit_user_path(id: 0)
          end
        when :memorial
          case action
            when :index
              get user_memorials_path(user_id: 0)
              @object_name = :user
            when :show
              get memorial_path(id: 0)
              @object_name = :memorial
            when :privacy_settings_for_get
              get privacy_settings_memorial_path(id: 0)
              @object_name = :memorial
            when :privacy_settings_for_patch
              patch privacy_settings_memorial_path(id: 0)
              @object = memorial_1
              @object_name = :memorial
            when :show_biography
              get show_biography_memorial_path(id: 0)
              @object_name = :memorial
          end
      end
    end
    it "display flash message" do
      expect(flash[:danger]).to eq I18n.t("flash.show.#{@object_name}.failed")
    end
    it "redirect to root URL" do
      should redirect_to(root_url)
    end
  end
end

RSpec.shared_examples "authorize access" do |model, action|
  context "correct user" do
    it "has current user equal owner user" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      case model
        when :user
          case action
            when :update
              patch user_path(id: user.id), params: {user: user.attributes}
            when :edit
              get edit_user_path(id: user.id)
          end
          @instance_object = assigns(:user)
        when :memorial
          memorial = memorial || create(:memorial, user: user)
          case action
            when :show
              get memorial_path(id: memorial.id)
            when :privacy_settings_for_get
              get privacy_settings_memorial_path(id: memorial.id)
            when :privacy_settings_for_patch
              patch privacy_settings_memorial_path(id: memorial.id)
            when :search_unshared_member
              get search_unshared_member_memorial_path(id: memorial.id),
                xhr: true
            when :show_biography
              get show_biography_memorial_path(id: memorial.id)
          end
          @instance_object = assigns(:memorial).user
      end
      expect(session[:user_id]).to eq @instance_object.id
    end
  end

  context "not correct user" do
    before do
      user_2 = create :user
      post login_path,
        params: {session: {email: user_2.email, password: user_2.password}}
      case model
        when :user
          case action
            when :update
              patch user_path(id: user.id)
            when :edit
              get edit_user_path(id: user.id)
          end
        when :memorial
          case action
            when :show
              get memorial_path(id: memorial.id)
            when :privacy_settings_for_get
              get privacy_settings_memorial_path(id: memorial_1.id)
            when :privacy_settings_for_patch
              patch privacy_settings_memorial_path(id: memorial_1.id)
            when :search_unshared_member
              get search_unshared_member_memorial_path(id: memorial_1.id)
            when :show_biography
              get show_biography_memorial_path(id: memorial.id)
          end
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

RSpec.shared_examples "validate object" do |model, action|
  context "user's valid" do
    before do
      case model
        when :user
          case action
            when :create
              post users_path, params: {user: user_attributes}
            when :update
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              patch user_path(id: user.id), params: {user: user.attributes}
          end
        when :memorial
          case action
            when :create
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              post memorials_path, params: {memorial: memorial_attributes}
          end
      end
    end
    if action.eql?(:create) && model.eql?(:user)
      it "login" do
        expect(session[:user_id]).to eq assigns(:user).id
      end
    end
    it "display flash message" do
      expect(flash[:success]).to eq I18n.t("#{model}.#{action}.successed")
    end
    it "redirect to user's page" do
      should redirect_to(assigns(model))
    end
  end

  context "user isn't valid" do
    before do
      case model
        when :user
          case action
            when :create
              user_attributes[:name] = ""
              post users_path, params: {user: user_attributes}
            when :update
              user[:name] = ""
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              patch user_path(id: user.id), params: {user: user.attributes}
          end
        when :memorial
          case action
            when :create
              post login_path,
                params: {session: {email: user.email, password: user.password}}
              memorial_attributes[:name] = ""
              post memorials_path, params: {memorial: memorial_attributes}
          end
      end
    end

    it "display flash message" do
      expect(flash.now[:danger]).to eq I18n.t("#{model}.#{action}.failed")
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
      expect(assigns(model).errors.full_messages).to eq [I18n
        .t("activerecord.attributes.#{model}.name") + " " +
        I18n.t("activerecord.errors.models.#{model}.attributes.name.blank")]
    end
  end
end

RSpec.shared_examples "authorize member" do |action|
  context "correct user" do
    it "has current user equal owner user" do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      memorial.share user
      case action
        when :show
          expect(get memorial_path(id: memorial.id)).to eq 200
        when :show_biography
          expect(get show_biography_memorial_path(id: memorial.id)).to eq 200
      end
    end
  end

  context "not correct user" do
    before do
      post login_path,
        params: {session: {email: user.email, password: user.password}}
      case action
        when :show
          get memorial_path(id: memorial.id)
        when :show_biography
          get show_biography_memorial_path(id: memorial.id)
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

RSpec.shared_examples "check authorize access privacy" do |action|
  it "memorial in public mode" do
    if action.eql? :show
      expect(get memorial_path(id: memorial_1.id)).to eq 200
    else
      expect(get show_biography_memorial_path(id: memorial_1.id)).to eq 200
    end
  end

  context "memorial in private mode" do
    let!(:memorial){create(:memorial, privacy_type: :private, user: user)}

    it_should_behave_like "authorize access", :memorial, action
  end

  context "memorial in shared mode" do
    let!(:memorial){create :memorial, privacy_type: :shared}

    it_should_behave_like "authorize member", action
  end
end
