require File.dirname(__FILE__) + '/spec_helper'

describe 'Routing' do
  it { should route(:get, '/home').to(:controller => 'home', :action => 'index') }
  it { should route(:get, '/demo_callplans').to(:controller => 'demo_callplans', :action => 'index') }
  it { should route(:post, '/demo_callplans').to(:controller => 'demo_callplans', :action => 'create') }
  it { should route(:put, "/demo_callplans/1").to(:controller => 'demo_callplans', :action => 'update', :id=>1) }
  it { should route(:post, '/freeswitch/callplan').to(:controller => 'freeswitch', :action => 'callplan') }
  it { should route(:post, '/freeswitch/ivr_menus').to(:controller => 'freeswitch', :action => 'ivr_menus') }
  it { should route(:get, '/callplans/1').to(:controller => 'callplans', :action => 'show', :id=> '1') }
end
