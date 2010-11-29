module Dorsey
  class Server  
    attr_reader :config
    attr_reader :articles
    
    
    def initialize config = {}, &blk
      @config = config.is_a?(Dorsey::Config) ? config : Dorsey::Config.new(config)
      @config.instance_eval(&blk) if block_given?
      
      @articles = Articles.new(@config[:article_path])
    end
    
    
    
  end
end
