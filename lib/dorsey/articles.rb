
module Dorsey
  class Articles < Array

    def initialize articles_path
      load_articles article_files articles_path
    end
    
    protected
    
    def article_files articles_path
      Dir["#{articles_path}/*.txt"].sort_by {|entry| File.basename(entry) }
    end
    
    def load_articles article_files
      article_files.each { |file| self << Article.new(file) }
    end
    

  end
end