require 'rspec'
require 'test_api'

describe 'apist' do

  before(:each) do
    @api = TestApi.new
  end

  it 'should generate pretty http error response' do
    result = @api.get404
    expect(result).to include :url, :error => {:status => 404, :reason => 'Not Found'}
  end

  it 'parses single blueprint value' do
    result = @api.menu_first
    expect(result).to eql('Welcome to Wikipedia')
  end

  it 'parses only filter objects' do
    blueprint = {
        title: 'My title',
        sub: {
            first: 1,
            second: 2
        }
    }
    result = @api.static_blueprint blueprint
    expect(result).to eql(blueprint)
  end

  it 'parses blueprint' do
    result = @api.index
    expect(result).to include :welcome_message => 'Welcome to Wikipedia'
    expect(result).to include :portals
    expect(result[:portals].first).to include :link, :label
  end

end