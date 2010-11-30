module Dorsey
  class Server  
    attr_reader :config
    attr_reader :articles
    
    
    def initialize config = {}, &blk
      @config = config.is_a?(Dorsey::Config) ? config : Dorsey::Config.new(config)
      @config.instance_eval(&blk) if block_given?
      
      @articles = Articles.new(@config[:article_path]).reverse
      
      puts ">> Initialized Dorsey Server, reading articles from: #{@config[:article_path]}"
    end
    
    def get_by_slug_part slug
      self.articles.select{ |item| item[:file] =~ /#{slug}/ }
    end
    
  end
end
