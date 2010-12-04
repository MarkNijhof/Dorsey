
class WebApplication < Sinatra::Base
  
  configure do
    set :public, './public'
    set :haml, :format => :html5
  end

  $blog_dorsey = Dorsey::Server.new do
    set :article_path, './blog/articles'
    set :article_prefix, "blog"
    if ENV['RACK_ENV'] != 'production'
      set :host, "http://local.cre8ivethought.com:3000/"
    else
      set :host, "http://cre8ivethought.com/"
    end
    set :disqus, "cre8ivethought"
    set :date, lambda {|now| now.strftime("%B #{now.day.ordinal} %Y") }
  end
  
  get '/' do
    File.read(File.join('public', 'index.html'))
  end
  
  get '/blog/index' do
    haml(:'root/index', :locals => { :title => "Cre8ive Thought", :dorsey_blog => $blog_dorsey})
  end
  
end
