
class WebApplication < Sinatra::Base
  
  configure do
    set :public, './public'
    set :haml, :format => :html5
  end

  get '/' do
    File.read(File.join('public', 'index.html'))
  end
  
  get '/blog/index' do
    haml :'root/index', :title => "Cre8ive Thought"
  end
  
end