require 'spec_helper'
describe 'addontools' do

  context 'with default options' do
    it {
      should include_class('addontools')
    }
  end
end
