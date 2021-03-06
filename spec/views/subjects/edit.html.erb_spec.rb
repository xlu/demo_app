require 'spec_helper'

describe "subjects/edit" do
  before(:each) do
    @subject = assign(:subject, stub_model(Subject,
      :name => "MyString",
      :birth_month => "MyString",
      :birth_day => "MyString",
      :birth_year => "MyString"
    ))
  end

  it "renders the edit subject form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", subject_path(@subject), "post" do
      assert_select "input#subject_name[name=?]", "subject[name]"
      assert_select "input#subject_birth_month[name=?]", "subject[birth_month]"
      assert_select "input#subject_birth_day[name=?]", "subject[birth_day]"
      assert_select "input#subject_birth_year[name=?]", "subject[birth_year]"
    end
  end
end
