require File.dirname(__FILE__) + '/spec_helper'

describe "Dorsey" do

  require 'dorsey'

  it "will find articles in the specified location" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.articles.count.should == 3
  end

  it "will process the articles in the specified location" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.articles[0].is_a?(Dorsey::Article).should == true
    dorsey.articles[0][:date].should == '2010-10-01'
    dorsey.articles[0][:title].should == 'Test 1 2 3'
    dorsey.articles[0][:author].should == 'Mark Nijhof'
    dorsey.articles[0][:published].should == true
  end

  it "will use the file date instead of provided meta information" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.articles[2][:date].should == '2010-11-03'
  end

  it "will use the slug independently of the defined order in the article" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.articles[0][:slug].should == 'test_3_2_1'
    dorsey.articles[1][:slug].should == 'test_6_5_4'
    dorsey.articles[2][:slug].should == 'test-7-8-9'
  end

  it "will use the slug independently of the defined order in the article" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.articles[0][:slug].should == 'test_3_2_1'
    dorsey.articles[1][:slug].should == 'test_6_5_4'
    dorsey.articles[2][:slug].should == 'test-7-8-9'
  end

  it "will get articles by slug part" do
    dorsey = Dorsey::Server.new do
      set :article_path, './spec/articles'
    end

    dorsey.get_by_slug_part('2010-11').count.should == 2
    dorsey.get_by_slug_part('2010').count.should == 3
  end

end
