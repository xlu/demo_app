require 'spec_helper'

describe "subjects/new" do
  before(:each) do
    assign(:subject, stub_model(Subject,
      :name => "MyString",
      :birth_month => "MyString",
      :birth_day => "MyString",
      :birth_year => "MyString"
    ).as_new_record)
  end

  it "renders new subject form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", subjects_path, "post" do
      assert_select "input#subject_name[name=?]", "subject[name]"
      assert_select "input#subject_birth_month[name=?]", "subject[birth_month]"
      assert_select "input#subject_birth_day[name=?]", "subject[birth_day]"
      assert_select "input#subject_birth_year[name=?]", "subject[birth_year]"
    end
  end
end
