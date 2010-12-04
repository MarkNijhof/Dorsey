require 'date'
require 'rack'
require 'rdiscount'

module Dorsey
  class Article < Hash
    Defaults = {
      :publish_date => "",
      :body => "",
      :summary => "",
      :file => ""
    }

    def initialize article_file, config
      self[:file] = article_file
      @config = config
      load_article article_file
    end

    def [] key
      return self[:__slug] || self[:title].slugize if key == :slug
      super
    end
    
    def method_missing m, *args, &blk
      self[m.to_sym] || super
    end

    protected
        
    def markdown text
      if (options = @config[:markdown])
        Markdown.new(text.to_s.strip, *(options.eql?(true) ? [] : options)).to_html
      else
        text.strip
      end
    end

    def get_summary body
#      delimiter = body.split(@config[:summary_delimiter]).first
#      split = delimiter.length > @config[:summary_length] ? @sconfig[:summary_legth] : delimiter.length
#      body.match(/(.{1,#{@config[:summary_length]}}.*?)(\n|\Z)/m).to_s

      sum = if body =~ @config[:summary_delimiter]
        body.split(@config[:summary_delimiter]).first
      else
        body.match(/(.{1,#{@config[:summary_length]}}.*?)(\n|\Z)/m).to_s
      end
      sum.length == body.length ? sum : sum.strip.sub(/\.\Z/, '&hellip;')
    end

    def load_article article_file
      raw_meta_data, body = File.read(article_file).split(/\n\n/, 2)
      self[:body] = markdown body
      self[:summary] = markdown(get_summary(body))
      self.update abstract_meta_data(article_file, raw_meta_data)
    end
    
    def abstract_meta_data article_file, raw_meta_data
      meta_data = YAML.load(raw_meta_data).inject({}) {|h, (k,v)| h.merge(k.to_sym => v) }
      
      article_file =~ /\/(\d{4}-\d{2}-\d{2})[^\/]*$/ 
      (date = $1)

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
