require File.dirname(__FILE__) + '/../../spec_helper'
require 'rexml/document'

describe "/service_instances/directory.xml.builder" do
  before do
    @number_matcher = "1234567890"
    assigns[:inbound_number] = @number_matcher
    @inbound_number_manager = Factory.create(:inbound_number_manager)
    assigns[:inbound_number_manager] =  @inbound_number_manager
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
    xml.elements['/document/section/domain/@name'].value.should == '$${domain}'
  end

  it 'should render a group element with an name of default' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/@name'].value.should == 'default'
  end

  it 'should render a user element with an id of the @number_matcher' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/users/user/@id'].value.should == @number_matcher
  end

  it 'should render a http-allowed-api element element with the value of voicemail' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/users/user/params/param/@http-allowed-api'].value.should == "voicemail"
  end

  it 'should render a voicemail password element element with the correct value' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/users/user/params/param/@vm-password'].value.should == @inbound_number_manager.voicemail_password
  end
end

