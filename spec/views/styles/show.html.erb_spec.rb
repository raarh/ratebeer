require 'spec_helper'

describe "styles/show" do
  before(:each) do
    @style = assign(:style, stub_model(Style,
      :style => "Style",
      :description => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Style/)
    rendered.should match(/MyText/)
  end
end
