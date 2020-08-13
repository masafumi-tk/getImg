require 'twitter'
require 'rubygems'
require 'yaml'
require 'fastimage'
require 'open-uri'
require 'FileUtils'
#### Get your twitter keys & secrets:
#### https://dev.twitter.com/docs/auth/tokens-devtwittercom
  
  def get_tweet_img()
    twitter_config = YAML.load_file('config/appconfig.yml')
    client = Twitter::REST::Client.new do |config|
      config.consumer_key = twitter_config["twitterconfig"]["consumer_key"]
      config.consumer_secret = twitter_config["twitterconfig"]["consumer_secret"]
      config.access_token = twitter_config["twitterconfig"]["access_token"]
      config.access_token_secret = twitter_config["twitterconfig"]["access_token_secret"]
    end
    count = 0
    client.favorites("pieel18",{count:200 ,page:5}).each do |tweet|
      #puts tweet.full_text
      tweet.media.each do |media|
        #puts media.media_url
        save_image(media.media_url,tweet[:user][:screen_name])
	count = count + 1
      end     
    end
    client.update(count.to_s + "枚の画像を保存しました")
    puts count

  end

  def save_image(url,accountname)
    fileName = File.basename(url)
    dirName = "img/"+ accountname + '/'
    filePath = dirName + fileName
    # create folder if not exist
    FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)
 
    # write image adata
    open(filePath, 'wb') do |output|
      open(url) do |data|
        output.write(data.read)
      end
    end
  end

 get_tweet_img
