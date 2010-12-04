
class WebApplication < Sinatra::Base
  
  configure do
    set :public, './public'
    set :haml, :format => :html5
  end

  $blog_dorsey = Dorsey::Server.new do
    set :article_path, './blog/articles'
  end
  
  get '/' do
    File.read(File.join('public', 'index.html'))
  end
  
  get '/blog/index' do
    haml(:'root/index', :locals => { :title => "Cre8ive Thought", :dorsey_blog => $blog_dorsey})
  end
  
end
