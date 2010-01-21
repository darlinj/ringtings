require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntryController do
  describe "deleting an entry" do
    before do
      @callplan = mock_model Callplan
      @action = mock_model Action, :callplan => @callplan
      @ivr_menu = mock_model IvrMenu, :action => @action
      @ivr_menu_entry = mock_model IvrMenuEntry, :ivr_menu => @ivr_menu
      IvrMenuEntry.stub(:destroy)
      IvrMenuEntry.stub(:find).and_return @ivr_menu_entry
      controller.stub(:signed_in?).and_return true
    end

    def do_delete
      delete :destroy, :id => @ivr_menu_entry.id
    end

    it "deletes the ivr menu entry" do
      IvrMenuEntry.should_receive(:destroy).with(@ivr_menu_entry.id)
      do_delete
    end

    describe "when signed in" do
      it "should redirect to the callplan show url" do
        do_delete
        response.should redirect_to(callplan_path(@callplan.id))
      end
    end

    describe "when NOT signed in" do
      it "should redirect to the demo callplan show url" do
        controller.stub(:signed_in?).and_return false
        do_delete
        response.should redirect_to(demo_callplan_path(@callplan.id))
      end
    end
  end
end
