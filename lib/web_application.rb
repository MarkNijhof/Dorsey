
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
    haml(:'blog/index', :locals => { :title => "Cre8ive Thought", :articles => $blog_dorsey.articles})
  end

  get '/blog/*' do
    article = $blog_dorsey.get_by_slug params[:splat][0]

    haml(:'blog/article', :locals => { :title => "Cre8ive Thought - #{article[0].title}", :post => article[0]} )
  end
  
end
