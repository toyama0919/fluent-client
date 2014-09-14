require 'spec_helper'
require 'fluent/client'

describe Fluent::Client do
  it 'should have a VERSION constant' do
    subject.const_get('VERSION').should_not be_empty
  end

  it 'core parse_text csv' do
    @core = Core.new
    results = @core.parse_text('csv', nil, 'log_date,host,url', '2014-01-01,localhost,/hoge/test')
    results.first['log_date'].should == '2014-01-01'
    results.first['host'].should == 'localhost'
    results.first['url'].should == '/hoge/test'
  end
end
