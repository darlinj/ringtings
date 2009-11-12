require File.dirname(__FILE__) + '/../../spec_helper'
require 'rexml/document'

describe "/service_instances/ivr_menus.xml.builder" do
  before do
    @name = "some_name"
    @long_greeting = "say: some text which for some reason I feel should long"
    @action1 = "some action"
    @action2 = "some other action"
    @digits1 = "1"
    @digits2 = "2"
    @params1 = "some params"
    @params2 = "some other params"
    @ivr_entry1 = mock_model IvrMenuEntry, :action=> @action1, :digits => @digits1 , :parameters => @params1
    @ivr_entry2 = mock_model IvrMenuEntry, :action=> @action2, :digits => @digits2 , :parameters => @params2
    @ivr_menu_entries = [@ivr_entry1,@ivr_entry2]
    @ivr_menu = mock_model IvrMenu, :name => @name, :long_greeting => @long_greeting, :ivr_menu_entries => @ivr_menu_entries
    assigns[:ivr_menu] = @ivr_menu
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
    xml.elements['//menus/menu/@name'].value.should == @name
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
    xml.elements['//menus/menu/@greet-long'].value.should == @long_greeting
  end

  it 'has a menu element with a greet-short attribute starting with "say"' do
    xml = do_render
    xml.elements['//menus/menu/@greet-short'].value.should == @long_greeting
  end

  it 'has a menu element with a invalid-sound attribute starting with "say"' do
    xml = do_render
    xml.elements['//menus/menu/@invalid-sound'].value.should =~ /say.*/
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
      describe 'first entry' do
        it 'has an action attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[1]') do |entry|
            entry.attribute('action').value.should == @action1
          end
        end
        it 'has an digits attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[1]') do |entry|
            entry.attribute('digits').value.should == @digits1
          end
        end
        it 'has an params attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[1]') do |entry|
            entry.attribute('params').value.should == @params1
          end
        end
      end
      describe 'second entry' do
        it 'has an action attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[2]') do |entry|
            entry.attribute('action').value.should == @action2
          end
        end
        it 'has an digits attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[2]') do |entry|
            entry.attribute('digits').value.should == @digits2
          end
        end
        it 'has an params attribute' do
          xml = do_render
          REXML::XPath.each(xml,'//entry/[2]') do |entry|
            entry.attribute('params').value.should == @params2
          end
        end
      end
    end 
  end
end

