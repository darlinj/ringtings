require File.dirname(__FILE__) + '/spec_helper'

describe 'Routing' do
  it { should route(:get, '/home').to(:controller => 'home', :action => 'index') }
  it { should route(:post, '/callplans').to(:controller => 'callplans', :action => 'create') }
  it { should route(:put, "/callplans/1").to(:controller => 'callplans', :action => 'update', :id=>1) }
  it { should route(:get, '/callplans').to(:controller => 'callplans', :action => 'index') }
  it { should route(:get, '/freeswitch').to(:controller => 'freeswitch', :action => 'index') }
  it { should route(:post, '/freeswitch').to(:controller => 'freeswitch', :action => 'create') }
end
