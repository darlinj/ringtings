require File.dirname(__FILE__) + '/../../spec_helper'
require 'rexml/document'

describe "/service_instances/directory.xml.builder" do
  before do
    @number_matcher = "1234567890"
    assigns[:inbound_number] = @number_matcher
  end

  def do_render
    render 'freeswitch/directory.xml.builder'
    REXML::Document.new(response.body)
  end

  it 'should render a document element with ia type of freeswitch/xml' do
    xml = do_render
    xml.elements['/document/@type'].value.should == 'freeswitch/xml'
  end

  it 'should render a section element with a name of directory' do
    xml = do_render
    xml.elements['/document/section/@name'].value.should == 'directory'
  end

  it 'should render a domain element with a name matching the domain for the server' do
    xml = do_render
    xml.elements['/document/section/domain/@name'].value.should == 'somename'
  end

  #it 'should render a extension element with a name of the @number_matcher' do
    #xml = do_render
    #xml.elements['/document/section/context/extension/@name'].value.should == @number_matcher
  #end

  #it 'should render a condition element with a field of destination_number' do
    #xml = do_render
    #xml.elements['/document/section/context/extension/condition/@field'].value.should == 'destination_number'
  #end

  #it 'should render an action element with a application element of the assigned application name' do
    #xml = do_render
    #xml.elements['/document/section/context/extension/condition/action/@application'].value.should == "#{@application_name}"
  #end

  #it 'should render an action element with a data element of the assigned application data' do
    #xml = do_render
    #xml.elements['/document/section/context/extension/condition/action/@data'].value.should == "#{@application_data}"
  #end
end

