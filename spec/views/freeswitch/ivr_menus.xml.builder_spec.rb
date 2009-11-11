require File.dirname(__FILE__) + '/../../spec_helper'
require 'rexml/document'

describe "/service_instances/ivr_menus.xml.builder" do
  before do
    @phone_number = "011111111111"
    @company_name = "Fillious Fog"
    @callplan = mock_model Callplan, :company_name => @company_name
    @employee = mock_model Employee, :phone_number => @phone_number
    @callplan.stub(:employee).and_return @employee
    @inbound_number = mock_model InboundNumberManager, :phone_number => "022222222222"
    @callplan.stub(:inbound_number).and_return @inbound_number
    assigns[:callplan] = @callplan
  end

  def do_render
    render 'freeswitch/ivr_menus.xml.builder'
    REXML::Document.new(response.body)
  end

  it 'should render a document element with ia type of freeswitch/xml' do
    xml = do_render
    xml.elements['/document/@type'].value.should == 'freeswitch/xml'
  end

  it 'should have a menus element' do
    xml = do_render
    xml.elements['/document/section/configuration/menus'].should_not be_nil
  end

  it 'has a menu element with a tts-engine attribute of "Cepstral"' do
    xml = do_render
    xml.elements['//menus/menu/@tts-engine'].value.should == 'Cepstral'
  end

  it 'has a menu element with a tts-voice attribute of "Lawrence-8kHz"' do
    xml = do_render
    xml.elements['//menus/menu/@tts-voice'].value.should == 'Lawrence-8kHz'
  end

  it 'has a menu element with a name attribute of "ivr_menu_<phone_number>"' do
    xml = do_render
    xml.elements['//menus/menu/@name'].value.should == "ivr_menu_#{@inbound_number.phone_number}"
  end

  it 'has a menu element with a tts-engine attribute of "Cepstral"' do
    xml = do_render
    xml.elements['//menus/menu/@tts-engine'].value.should == 'Cepstral'
  end

  it 'has a menu element with a greet-long attribute starting with "say"' do
    xml = do_render
    xml.elements['//menus/menu/@greet-long'].value.should =~ /say.*/
  end

  it 'has a menu element with a greet-long attribute starting with the company name' do
    xml = do_render
    xml.elements['//menus/menu/@greet-long'].value.should =~ /.*#{@company_name}.*/
  end

  it 'has a menu element with a greet-short attribute starting with "say"' do
    xml = do_render
    xml.elements['//menus/menu/@greet-short'].value.should =~ /say.*/
  end

  it 'has a menu element with a invalid-sound attribute starting with "say"' do
    xml = do_render
    xml.elements['//menus/menu/@invalid-sound'].value.should =~ /say.*/
  end

  it 'should have a element that forwards stuff to the employee number' do
    xml = do_render
    xml.elements['//menus/menu/entry/@param'].value.should =~ /transfer #{@phone_number} XML default.*/
  end

  it 'has a menu element with a timeout attribute that is an integer' do
    xml = do_render
    xml.elements['//menus/menu/@timeout'].value.should =~ /\d*/
  end

  it 'has a menu element with a max-failures attribute that is an integer' do
    xml = do_render
    xml.elements['//menus/menu/@max-failures'].value.should =~ /\d*/
  end

  describe 'the menu items' do
    it 'has 3 entries' do
      xml = do_render
      xml.elements['count(//entry)'].should > 1
    end
    describe 'each entry' do
      it 'has an action attribute' do
        xml = do_render
        REXML::XPath.each(xml,'//entry') do |entry|
          entry.attribute('action').should_not be_nil
        end
      end
      it 'has an digits attribute' do
        xml = do_render
        REXML::XPath.each(xml,'//entry') do |entry|
          entry.attribute('digits').should_not be_nil
        end
      end
    end 
  end
end

