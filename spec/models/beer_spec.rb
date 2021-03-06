require 'spec_helper'

describe Beer do
  let(:brewery){ Brewery.create name:"Koff", year:1897}
  it "with name and style is valid" do
    porter = Style.create style:"Porter"
    beer = Beer.create name:"Porter", style_id:porter.id, brewery_id:brewery.id
    expect(beer).to be_valid
    beer = Beer.create name:"Porter"
    expect(beer).not_to be_valid
    beer = Beer.create name:"Porter"
    expect(beer).not_to be_valid
    expect(Beer .count).to eq(1)
  end
  it "belongs to a brewery" do
    porter = Style.create style:"Porter"
    beer = Beer.create name:"Porter", style_id:porter.id, brewery_id: brewery.id
    beer.brewery.id.should == brewery.id
    expect(beer).to be_valid

  end
end
