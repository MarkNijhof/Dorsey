require 'date'
require 'rack'

module Dorsey
  class Article < Hash
    Defaults = {
      :publish_date => "",
      :body => "",
      :file => ""
    }

    def initialize article_file
      self[:file] = article_file
      load_article article_file
    end

    def [] key
      return self[:__slug] || self[:title].slugize if key == :slug
      
      super
    end

    protected
        
    def load_article article_file
      raw_meta_data, self[:body] = File.read(article_file).split(/\n\n/, 2)

      self.update abstract_meta_data(article_file, raw_meta_data)
    end
    
    def abstract_meta_data article_file, raw_meta_data
      meta_data = YAML.load(raw_meta_data).inject({}) {|h, (k,v)| h.merge(k.to_sym => v) }
      
      article_file =~ /\/(\d{4}-\d{2}-\d{2})[^\/]*$/ 
      (date = $1)
#      ($1 ? {:date => $1} : {}).merge meta_data
      meta_data[:date] = date
      rename_slug_key meta_data
    end
    
    def rename_slug_key meta_data
      meta_data[:__slug] = meta_data[:slug] if !meta_data[:slug].nil?
      meta_data.delete :slug
      meta_data
    end

  end
end