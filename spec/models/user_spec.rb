require 'spec_helper'

describe User do
  it "has the username set correctly" do
    user = User.new username:"Pekka"

    user.username.should == "Pekka"
  end
  it "is not saved without a password" do
    user = User.create username:"Pekka"

    expect(user).not_to be_valid
    expect(User.count).to eq(0)
  end
  describe "with a proper password" do
    let(:user){ FactoryGirl.create(:user) }

    it "is saved" do
      expect(user).to be_valid
      expect(User.count).to eq(1)
    end

    it "and with two ratings, has the correct average rating" do
      user.ratings << FactoryGirl.create(:rating)
      user.ratings << FactoryGirl.create(:rating2)

      expect(user.ratings.count).to eq(2)
      expect(user.rating_average).to eq(15.0)
    end
    describe "and password" do
      it "is longer than 4 characters" do
        expect(User.create username:"Pekka", password:"Sec1", password_confirmation:"Sec1").to be_valid
        expect(User.create username:"Masa", password:"Secr1", password_confirmation:"Secr1").to be_valid
        expect(User.count).to eq(2)
        expect(User.create username:"Peksi", password:"Se1", password_confirmation:"Se1").not_to be_valid
        expect(User.count).to eq(2)
      end
      it "contain at least one uppercase character" do
        expect(User.create username:"Peksi", password:"sec1", password_confirmation:"sec1").not_to be_valid
        expect(User.create username:"Masa", password:"Sec1", password_confirmation:"Sec1").to be_valid
        expect(User.create username:"Pekka", password:"SEc1", password_confirmation:"SEc1").to be_valid
        expect(User.count).to eq(2)
      end
      it "contain at least one number" do
        expect(User.create username:"Peksi", password:"Secr", password_confirmation:"Secr").not_to be_valid
        expect(User.create username:"Masa", password:"Secr1", password_confirmation:"Secr1").to be_valid
        expect(User.create username:"Pekka", password:"SEc12", password_confirmation:"SEc12").to be_valid
        expect(User.count).to eq(2)
      end
    end
  end

  describe "favorite beer" do
    let(:user){FactoryGirl.create(:user) }
    it "has method for determining one" do
      user.should respond_to :favorite_beer
    end
    it "without ratings does not have one" do
      expect(user.favorite_beer).to eq(nil)
    end
    it "is the only rated if only one rating" do
      lager = Style.create style:"Weizen"
      brewery = FactoryGirl.create(:brewery )
      beer = create_beer_with_style_and_rating(lager,"Iso 3",user,brewery,25);

      expect(user.favorite_beer).to eq(beer)
    end
    it "is the one with highest rating if several rated" do
      vehna = Style.create style:"Weizen"
      brewery = FactoryGirl.create(:brewery )

      create_beer_with_style_and_rating(vehna,"Iso 1",user,brewery,2);
      create_beer_with_style_and_rating(vehna,"Iso 2",user,brewery,20);
      create_beer_with_style_and_rating(vehna,"Iso 4",user,brewery,22);

      best =       create_beer_with_style_and_rating(vehna,"Iso 3",user,brewery,25);

      expect(user.favorite_beer).to eq(best)
    end
  end
  describe "favorite style" do
    let(:user){FactoryGirl.create(:user) }
    let(:brewery ){FactoryGirl.create(:brewery ) }

    it "has method for determining one" do
      user.should respond_to :favorite_style
    end
    it "without ratings does not have one" do
      expect(user.favorite_style).to eq(nil)
    end
    it "is the only rated if only one rating" do
      lager = Style.create style:"Lager"
      create_beer_with_style_and_rating(lager,"olut",user,brewery,25)

      user.favorite_style.id.should == lager.id
    end
    it "is the one with highest rating if several rated" do
      lager = Style.create style:"Lager"
      vehna = Style.create style:"Weizen"

      create_beer_with_style_and_rating(lager,"Iso 3",user,brewery,10);
      create_beer_with_style_and_rating(lager,"Tiukka 4",user,brewery,25);

      create_beer_with_style_and_rating(vehna,"Lempeä vehnä",user,brewery,30);
      user.favorite_style.id.should == lager.id
      create_beer_with_style_and_rating(vehna,"Lempeä vehnä",user,brewery,30);
      user.favorite_style.id.should == vehna.id
    end
  end
end

def create_beer_with_rating(score, user)
  style = Style.where(style:"Lager")
  if style.nil?
    style = Style.create style:"Lager"
  end
  name = "#{score}olut"
  brewery = FactoryGirl.create(:brewery)
  beer = Beer.create(name:name, brewery_id:brewery.id,style_id:style.id)
  FactoryGirl.create(:rating, score:score, beer:beer, user:user)
  beer
end

def create_beers_with_ratings(*scores, user)
  scores.each do |score|
    create_beer_with_rating(score, user)
  end
end

