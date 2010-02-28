require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DummyController < ApplicationController
  def some_action
    redirect_to_callplan(params['ivr_menu_entry'])
  end
end

describe ApplicationController do
  controller_name :dummy
  describe "redirecting to the correct callplan" do
    before do
      @callplan = mock_model Callplan
      @action = mock_model Action, :callplan => @callplan
      @ivr_menu = mock_model IvrMenu, :action => @action
      @ivr_menu_entry = mock_model IvrMenuEntry, :ivr_menu => @ivr_menu
      controller.stub(:signed_in?).and_return true
    end

    def do_redirect
      get :some_action, :ivr_menu_entry => @ivr_menu_entry
    end

    describe "when signed in" do
      it "should redirect to the callplan show url" do
        do_redirect
        response.should redirect_to(callplan_path(@callplan.id))
      end
    end

    describe "when NOT signed in" do
      it "should redirect to the demo callplan show url" do
        controller.stub(:signed_in?).and_return false
        do_redirect
        response.should redirect_to(demo_callplan_path(@callplan.id))
      end
    end
  end
end
