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
    xml.elements['/document/section/domain/@name'].value.should == '$${domain}'
  end
    #<groups>
      #<group name="default">
        #<users>
           #<user id="1000">
            #<params>
              #<param name="password" value="$${default_password}"/>
              #<param name="vm-password" value="1000"/>
            #</params>
            #<variables>
              #<variable name="toll_allow" value="domestic,international,local"/>
              #<variable name="accountcode" value="1000"/>
              #<variable name="user_context" value="default"/>
              #<variable name="effective_caller_id_name" value="Extension 1000"/>
              #<variable name="effective_caller_id_number" value="1000"/>
              #<variable name="outbound_caller_id_name" value="$${outbound_caller_name}"/>
              #<variable name="outbound_caller_id_number" value="$${outbound_caller_id}"/>
              #<variable name="callgroup" value="techsupport"/>
            #</variables>
          #</user>

        #</users>
      #</group>


  it 'should render a group element with an name of default' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/@name'].value.should == 'default'
  end

  it 'should render a user element with an id of the @number_matcher' do
    xml = do_render
    xml.elements['/document/section/domain/groups/group/users/user/@id'].value.should == @number_matcher
  end
end

