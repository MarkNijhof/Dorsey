module Dorsey
  class Server  
    attr_reader :config
    attr_reader :articles
    
    def initialize config = {}, &blk
      @config = config.is_a?(Dorsey::Config) ? config : Dorsey::Config.new(config)
      @config.instance_eval(&blk) if block_given?
      
      @articles = Articles.new(@config).reverse
      
      puts ">> Initialized Dorsey Server, reading articles from: #{@config[:article_path]}"
    end
    
    def get_by_slug slug
      slug =~ /^(.+)\/$/
      slug = $1 || slug
      self.articles.select{ |item| item[:url] =~ /#{slug}/ }
    end
    
  end
end
