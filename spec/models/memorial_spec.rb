require 'rails_helper'

RSpec.describe Memorial, type: :model do
  describe "validations" do
    context "validate name" do
      it {should validate_presence_of(:name)}
      it {should validate_length_of(:name).is_at_most(Settings.length.digit_50)}
    end

    context "validate relationship" do
      it {should validate_presence_of(:relationship)}
    end

    context "validate biography" do
      it {should validate_length_of(:biography)
        .is_at_most(Settings.length.digit_1000)}
    end
  end

  describe "enum" do
    it {should define_enum_for(:privacy_type).with_values(public: 0, private: 1, shared: 2)
          .with_prefix(true)}
  end

  describe "associations" do
    it {should have_many(:placetimes).dependent(:destroy)}

    it {should have_many(:contributions).dependent(:destroy)}

    it {should have_many(:user_relations)
      .class_name(AccessPrivacy.name).dependent(:destroy)}

    it {should have_many(:shared_users)
      .through(:user_relations).source(:user)}

    it {should have_one_attached(:avatar)}
  end

  let!(:owner){create :user}
  let!(:memorial){create :memorial, user: owner}

  describe "methods" do
    context "format_date" do
      it "return formated date if input is invalid" do
        params = {"date(3i)"=>"15", "date(2i)"=>"3", "date(1i)"=>"1916"}
        expect(memorial.format_date params).to eq Date.new(1916,3,15)
      end
      it "return nil if input is not invalid" do
        params = {"date(3i)"=>"0", "date(2i)"=>"3", "date(1i)"=>"1916"}
        expect(memorial.format_date params).to eq nil
      end
    end

    context "build_placetimes" do
      it "build 2 placetimes" do
        memorial.build_placetimes
        expect(memorial.placetimes.size).to eq 2
      end
    end

    context "placetimes_attributes=" do
      it "build 2 placetimes when build memorial with placetimes_attributes" do
        placetimes_attributes = {"0"=>{"date(3i)"=>"18", "date(2i)"=>"10",
          "date(1i)"=>"1916"}, "1"=>{ "date(3i)"=>"18", "date(2i)"=>"12",
          "date(1i)"=>"1946"}}
        memorial = Memorial.new(name: "Hai",
          placetimes_attributes: placetimes_attributes)
        expect(memorial.placetimes.first.date).to eq Date.new(1916,10,18  )
      end
    end

    context "date" do
      it "return birthdate in birth_placetime" do
        memorial.placetimes.build(date: Date.new(1916,3,15), is_born: true)
        expect(memorial.date :birth).to eq Date.new(1916,3,15)
      end

      it "return deathdate in death_placetime" do
        memorial.placetimes.build(date: Date.new(2000,3,10), is_born: false)
        expect(memorial.date :death).to eq Date.new(2000,3,10)
      end

      it "return nil if placetime have nil date" do
        memorial.placetimes.build
        expect(memorial.date :death).to eq nil
      end

      it "return nil if memorial dont have placetime yet" do
        expect(memorial.date :death).to eq nil
      end
    end

    context "year" do
      it "return year in date of birth_placetime" do
        memorial.placetimes.build(date: Date.new(1916,3,15), is_born: true)
        expect(memorial.year :birth).to eq 1916
      end

      it "return year in date of death_placetime" do
        memorial.placetimes.build(date: Date.new(2000,3,10), is_born: false)
        expect(memorial.year :death).to eq 2000
      end

      it "return ? if placetime have nil date" do
        memorial.placetimes.build
        expect(memorial.year :death).to eq "?"
      end

      it "return ? if memorial dont have placetime yet" do
        expect(memorial.year :death).to eq "?"
      end
    end

    context "place" do
      it "return place in birth_placetime" do
        memorial.placetimes.build(location: "Hoi An", is_born: true)
        expect(memorial.place :birth).to eq "Hoi An"
      end

      it "return year in death_placetime" do
        memorial.placetimes.build(location: "Ha Noi", is_born: false)
        expect(memorial.place :death).to eq "Ha Noi"
      end

      it "return nil if placetime have nil location" do
        memorial.placetimes.build
        expect(memorial.place :death).to eq nil
      end

      it "return nil if memorial dont have placetime yet" do
        expect(memorial.place :death).to eq nil
      end
    end

    context "share?" do
      it "add user to shared list" do
        other_user = create(:user)
        memorial.share other_user
        expect(memorial.share? other_user).to eq true
      end
    end

    context "share" do
      it "add user to shared list" do
        other_user = create(:user)
        memorial.share other_user
        expect(memorial.shared_users.include? other_user).to eq true
      end
    end

    context "unshare" do
      it "delete user to shared list" do
        other_user = create(:user)
        memorial.unshare other_user
        expect(memorial.shared_users.include? other_user).to eq false
      end
    end
  end

  describe "scopes" do
    let!(:memorial_1){create :memorial, name: "C"}
    let!(:memorial_2){create :memorial, name: "B"}
    let!(:memorial_3){create :memorial, name: "A"}
    context "sort by name asc" do
      it "return sorted list by asc" do
        memorial.destroy
        expect(Memorial.by_name_asc).to eq [memorial_3, memorial_2, memorial_1]
      end
    end

    context "list memorial by mode " do
      it "return list of public memorial in guest mode" do
        expect(Memorial.type_of_index(nil)).to eq [memorial, memorial_1,
          memorial_2, memorial_3]
      end

      it "return list of user's memorial in user mode" do
        expect(Memorial.type_of_index(owner)).to eq [memorial]
      end
    end
  end
end
