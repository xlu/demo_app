require 'spec_helper'

describe "subjects/show" do
  before(:each) do
    @subject = assign(:subject, stub_model(Subject,
      :name => "Name",
      :birth_month => "Birth Month",
      :birth_day => "Birth Day",
      :birth_year => "Birth Year"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Name/)
    rendered.should match(/Birth Month/)
    rendered.should match(/Birth Day/)
    rendered.should match(/Birth Year/)
  end
end
