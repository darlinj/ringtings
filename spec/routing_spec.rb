require File.dirname(__FILE__) + '/spec_helper'

describe 'Routing' do
  it { should route(:get, '/home').to(:controller => 'home', :action => 'index') }
  it { should route(:get, '/demo_callplans').to(:controller => 'demo_callplans', :action => 'index') }
  it { should route(:post, '/demo_callplans').to(:controller => 'demo_callplans', :action => 'create') }
  it { should route(:put, "/demo_callplans/1").to(:controller => 'demo_callplans', :action => 'update', :id=>1) }
  it { should route(:put, "/demo_callplans/generate_full_demo_callplan/1").to(:controller => 'demo_callplans', :action => 'generate_full_demo_callplan', :id=>1) }
  it { should route(:put, "/demo_callplans/create_user/1").to(:controller => 'demo_callplans', :action => 'create_user', :id=>1) }
  it { should route(:get, "/demo_callplans/1").to(:controller => 'demo_callplans', :action => 'show', :id=>1) }
  it { should route(:get, '/voicemail').to(:controller => 'voicemail', :action => 'index') }
  it { should route(:get, '/callplans/1').to(:controller => 'callplans', :action => 'show', :id=> '1') }
  it { should route(:put, '/callplans/1').to(:controller => 'callplans', :action => 'update', :id=> '1') }
  it { should route(:delete, "/ivr_menu_entries/1").to(:controller => 'ivr_menu_entries', :action => 'destroy', :id=>1) }
  it { should route(:post, "/ivr_menu_entries").to(:controller => 'ivr_menu_entries', :action => 'create') }
  it { should route(:get, "/ivr_menu_entry_prototypes").to(:controller => 'ivr_menu_entry_prototypes', :action => 'index') }
  it { should route(:get, "/play_audio_file_menu_entries/1/edit").to(:controller => 'play_audio_file_menu_entries', :action => 'edit', :id =>1) }
  it { should route(:put, "/play_audio_file_menu_entries/1").to(:controller => 'play_audio_file_menu_entries', :action => 'update', :id =>1) }
  it { should route(:post, '/freeswitch/callplan').to(:controller => 'freeswitch', :action => 'callplan') }
  it { should route(:post, '/freeswitch/ivr_menus').to(:controller => 'freeswitch', :action => 'ivr_menus') }
  it { should route(:post, '/freeswitch/directory').to(:controller => 'freeswitch', :action => 'directory') }
  it { should route(:get, 'users/new').to(:controller => 'users', :action => 'new') }
  it { should route(:post, 'users').to(:controller => 'users', :action => 'create') }
  #it { should route(:post, 'audio_files').to(:controller => 'audio_files', :action => 'create') }
end
