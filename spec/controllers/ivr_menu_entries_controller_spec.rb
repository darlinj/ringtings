require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IvrMenuEntriesController do
  before do
    @callplan = mock_model Callplan
    @action = mock_model Action, :callplan => @callplan
    controller.stub(:signed_in?).and_return true
  end
  describe "creating an entry" do
    before do
      @type = "SyntheticVoiceMenuEntry"
      @ivr_menu = mock_model IvrMenu, :action=> @action
      @ivr_menu_entry = mock_model IvrMenuEntry
      @param_1_default = "some menu here"
      @ivr_menu_entry_prototype = mock_model IvrMenuEntryPrototype, :param_1_default => @param_1_default
      @expected_params = { :digits => "1", :param_1 => @param_1_default, :prototype => @ivr_menu_entry_prototype }
      IvrMenuEntryPrototype.stub(:find_by_name).with(@type).and_return @ivr_menu_entry_prototype
      SyntheticVoiceMenuEntry.stub(:new).and_return @ivr_menu_entry
      IvrMenu.stub(:find).with(@ivr_menu.id).and_return(@ivr_menu)
      @ivr_menu_entry.stub(:ivr_menu=)
      @ivr_menu.stub(:ivr_menu_entries).and_return nil
      @ivr_menu_entry.stub(:save)
    end

    def do_post
      post :create, :type=>@type, :ivr_menu_id=>@ivr_menu.id
    end

    it "creates the ivr menu entry" do
      SyntheticVoiceMenuEntry.should_receive(:new).with(@expected_params)
      do_post
    end

    it "assigns the menu entry to the menu" do
      @ivr_menu_entry.should_receive(:ivr_menu=).with @ivr_menu
      do_post
    end

    describe "set the digit to the first available" do
      describe "if there are existing menu entries with digits set" do
        before do
          @existing_ivr_menu_entry = mock_model SyntheticVoiceMenuEntry, :digits => "3", :ivr_menu=>@ivr_menu
          @ivr_menu.stub(:ivr_menu_entries).and_return [@existing_ivr_menu_entry]
        end

        it "should assign the next number up" do
          @ivr_menu_entry.should_receive(:digits=).with "4"
          do_post
        end
      end
    end
    it "saves the menu entry" do
      @ivr_menu_entry.should_receive(:save)
      do_post
    end
    describe "redirects the response to the relevant callplan page" do
      describe "when signed in" do
        it "should redirect to the callplan show url" do
          do_post
          response.should redirect_to(callplan_path(@callplan.id))
        end
      end

      describe "when NOT signed in" do
        it "should redirect to the demo callplan show url" do
          controller.stub(:signed_in?).and_return false
          do_post
          response.should redirect_to(demo_callplan_path(@callplan.id))
        end
      end
    end
  end
  describe "deleting an entry" do
    before do
      @ivr_menu = mock_model IvrMenu, :action => @action
      @ivr_menu_entry = mock_model IvrMenuEntry, :ivr_menu => @ivr_menu
      IvrMenuEntry.stub(:destroy)
      IvrMenuEntry.stub(:find).and_return @ivr_menu_entry
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
