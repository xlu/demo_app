require 'spec_helper'

describe "subjects/index" do
  before(:each) do
    assign(:subjects, [
      stub_model(Subject,
        :name => "Name",
        :birth_month => "Birth Month",
        :birth_day => "Birth Day",
        :birth_year => "Birth Year"
      ),
      stub_model(Subject,
        :name => "Name",
        :birth_month => "Birth Month",
        :birth_day => "Birth Day",
        :birth_year => "Birth Year"
      )
    ])
  end

  it "renders a list of subjects" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Birth Month".to_s, :count => 2
    assert_select "tr>td", :text => "Birth Day".to_s, :count => 2
    assert_select "tr>td", :text => "Birth Year".to_s, :count => 2
  end
end
