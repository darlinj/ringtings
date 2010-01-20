require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntryController do
  describe "deleting an entry" do
    before do
      request.env["HTTP_REFERER"] = "http://someurl.com/foo"
      @ivr_menu_entry = mock_model IvrMenuEntry
      IvrMenuEntry.stub(:destroy)
    end
    def do_delete
      delete :destroy, :id => @ivr_menu_entry.id
    end
    it "deletes the ivr menu entry" do
      IvrMenuEntry.should_receive(:destroy).with(@ivr_menu_entry.id)
      do_delete
    end
    it "should redirect to the referring url" do
      do_delete
      response.should redirect_to(:back)
    end
  end
end
