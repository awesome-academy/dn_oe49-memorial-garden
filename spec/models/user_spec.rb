require 'rails_helper'

RSpec.describe User, type: :model do
  describe "validations" do
    context "validate name" do
      it {should validate_presence_of(:name)}
      it {should validate_length_of(:name).is_at_most(Settings.length.digit_50)}
    end

    context "validate email" do
      it {should validate_presence_of(:email)}
      it {should validate_length_of(:email).is_at_most(Settings.length.digit_100)}
      it {should allow_value("thanh.lq011299@gmail.com").for(:email)}
      it {should_not allow_value("thanh.lq011299gmail.com").for(:email)}
      it "is not valid with duplicate email" do
        create :user, email: "hello@gmail.com"
        user = build(:user, email: "hello@gmail.com").save
        expect(user).to eq false
      end
    end

    context "validate password" do
      it {should have_secure_password}
      it {should validate_presence_of(:password)}
      it {should validate_length_of(:password)
        .is_at_least(Settings.length.digit_6)}
      it "is valid with nil password if its recorded" do
        user = create :user
        reload_user = User.find_by(id: user.id)
        expect(reload_user.save).to eq true
      end
    end
  end

  describe "associations" do
    it {should have_many(:memorials).dependent(:destroy)}

    it {should have_many(:contributions).dependent(:destroy)}

    it {should have_many(:memorial_relations)
      .class_name(AccessPrivacy.name).dependent(:destroy)}

    it {should have_many(:shared_memorials)
      .through(:memorial_relations).source(:memorial)}

    it {should have_one_attached(:avatar)}
  end

  let!(:owner){create :user}
  let!(:memorial){create :memorial, user: owner}

  describe "scopes" do
    it "return list of unshared member" do
      expect(User.unshared_member(memorial)).to eq User.all.excluding(owner)
    end
  end

  describe "methods" do
    context "wrote_tribute?" do
      it "return true if user have written tribute for memorial" do
        create :contribution_with_tribute, user: owner, memorial: memorial
        expect(owner.wrote_tribute?(memorial)).to eq true
      end
      it "return false if user haven't written tribute for memorial" do
        expect(owner.wrote_tribute?(memorial)).to eq false
      end
    end

    context "show_tribute" do
      it "return tribute if user have written tribute for memorial" do
        contribution = create :contribution_with_tribute,
          user: owner, memorial: memorial
        expect(owner.show_tribute(memorial)).to eq contribution.tribute
      end
      it "return nil if user haven't written tribute for memorial" do
        expect(owner.show_tribute(memorial)).to eq nil
      end
    end

    context "find_relation" do
      it "return relation between user and memorial" do
        shared_user = create :user
        memorial.shared_users << shared_user
        expect(shared_user.find_relation(memorial))
          .to eq AccessPrivacy.find_by(user: shared_user, memorial: memorial)
      end
    end
  end
end
