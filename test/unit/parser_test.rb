require 'test_helper'
require 'sample_tweet_data'

class ParserTest < ActiveSupport::TestCase
  context "Mirna Nazaire sample tweet" do
    setup do
      @parser = Parser.new
      @parser.text = "#haiti #need food #name Mirna Nazaire lives in #loc PAP at Bizoton 6 #12 #info neighborhood w/o food. People dying"
      @parser.valid_keys = %w{need name loc info}

      assert @map = @parser.parse
    end

    should "parse fields properly" do
      assert_equal "food", @map["need"]
      assert_equal "Mirna Nazaire lives in", @map["name"]
      assert_equal "PAP at Bizoton 6 \#12", @map["loc"]
      assert_equal "neighborhood w/o food. People dying", @map["info"]
    end

    should "parse extra properly" do
      assert_equal "\#haiti", @map["extra"]
    end
  end

  context "French hospital sample tweet" do
    setup do
      @parser = Parser.new
      @parser.text = "#haiti #offering hospital rooms #loc french lycee in rue marcadieux bourdon #num 30+ #info French hospital is open and ready 2 receive"
      @parser.valid_keys = %w{offering loc num info}

      assert @map = @parser.parse
    end

    should "parse fields properly" do
      assert_equal "hospital rooms", @map["offering"]
      assert_equal "french lycee in rue marcadieux bourdon", @map["loc"]
      assert_equal "30+", @map["num"]
      assert_equal "French hospital is open and ready 2 receive", @map["info"]
    end

    should "parse extra properly" do
      assert_equal "\#haiti", @map["extra"]
    end
  end

  context "Sample tweet data: " do
    setup do
      @parser = Parser.new
      @parser.valid_keys = %w{offering loc num info need name haiti}
    end

    SampleTweetData::TEXTS.each do |text|
      context text do
        setup do
          @parser.text = text
          @map = @parser.parse
        end

        should "parse cleanly" do
          assert @map
        end

        if text =~ /\#loc[^\#]*[^\s\#]/
          should "contain a loc value" do
            assert !@map["loc"].blank?
          end
        end
      end
    end
  end
end