require 'rails_helper'

RSpec.describe "statuses/edit", :type => :view do
  before(:each) do
    @status = assign(:status, Status.create!(
      :status => "MyText"
    ))
  end

  it "renders the edit status form" do
    render

    assert_select "form[action=?][method=?]", status_path(@status), "post" do

      assert_select "textarea#status_status[name=?]", "status[status]"
    end
  end
end
