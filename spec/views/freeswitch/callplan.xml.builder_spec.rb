require File.dirname(__FILE__) + '/../../spec_helper'
require 'rexml/document'

describe "/service_instances/callplan.xml.builder" do
  before do
    @number_matcher = "12345"
    assigns[:inbound_number] = @number_matcher
    @callplan = Factory :callplan, :company_name => @company_name
    @application_name = "some application"
    @application_data = "Well matron,  Well I say. oooh!"
    Factory :action, :callplan_id => @callplan.id, :application_name => @application_name, :application_data => @application_data
    assigns[:callplan] = @callplan
  end

  def do_render
    render 'freeswitch/callplan.xml.builder'
    REXML::Document.new(response.body)
  end

  it 'should render a document element with ia type of freeswitch/xml' do
    xml = do_render
    xml.elements['/document/@type'].value.should == 'freeswitch/xml'
  end

  it 'should render a section element with a name of dialplan' do
    xml = do_render
    xml.elements['/document/section/@name'].value.should == 'dialplan'
  end

  it 'should render a context element with a name of default' do
    xml = do_render
    xml.elements['/document/section/context/@name'].value.should == 'default'
  end

  it 'should render a extension element with a name of the @number_matcher' do
    xml = do_render
    xml.elements['/document/section/context/extension/@name'].value.should == @number_matcher
  end

  it 'should render a condition element with a field of destination_number' do
    xml = do_render
    xml.elements['/document/section/context/extension/condition/@field'].value.should == 'destination_number'
  end

  it 'should render an action element with a application element of the assigned application name' do
    xml = do_render
    xml.elements['/document/section/context/extension/condition/action/@application'].value.should == "#{@application_name}"
  end

  it 'should render an action element with a data element of the assigned application data' do
    xml = do_render
    xml.elements['/document/section/context/extension/condition/action/@data'].value.should == "#{@application_data}"
  end
end

