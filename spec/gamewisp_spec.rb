require 'spec_helper'

describe Gamewisp do
  it 'has a version number' do
    expect(Gamewisp::VERSION).not_to be nil
  end

  it 'app_data_path is valid when appname not set' do
    Gamewisp.appname = nil
    expected = File.join(Dir.home, '.local', 'share', 'gamewisp_client')
    expect(Gamewisp.app_data_path).to eq(expected)
  end

  it 'app_data_path is valid when appname set' do
    Gamewisp.appname = 'testapp'
    expected = File.join(Dir.home, '.local', 'share', 'testapp')
    expect(Gamewisp.app_data_path).to eq(expected)
  end

#  it 'does something useful' do
#    expect(false).to eq(true)
#  end
end
