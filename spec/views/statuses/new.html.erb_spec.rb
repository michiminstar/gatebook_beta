require 'rails_helper'

RSpec.describe "statuses/new", :type => :view do
  before(:each) do
    assign(:status, Status.new(
      :status => "MyText"
    ))
  end

  it "renders new status form" do
    render

    assert_select "form[action=?][method=?]", statuses_path, "post" do

      assert_select "textarea#status_status[name=?]", "status[status]"
    end
  end
end
