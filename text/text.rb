
module Tweet::PostTextTweet

  # Create this run method that accomplishes what the name of this
  # method insists
  #
  # As a return value send back a hash that has the following key/value pairs
  #   :success? => whether or not the method completed successfully
  #   :error => If it wasn't successful, add this key with
  #     the value being a string explaining the error
  #   any other key value pairs that show the results of this
  #
  # Example results:
  #  {:success? => false, :error => "Content was blank"}
  #
  #  {:success? => true,
  #   :tweet => tweet(tweet object),
  #   :tags => tags (array of tag objects)
  #  }
  #
  # Once you're comfortable with that, return an OpenStruct instead of a hash
  def run(input)
    if input[:content].length > 140
      return {:success? => false, :error => "Over character limit"}
    end

    t = Tweet.db.create_text_tweet(content: input[:content])

    if t.nil?
      return {:success? => false, :error = "Database couldn't store data"}
    end

    tags = input[:tags].map do |tag|
      tag = Tweet.db.get_or_create_tag(tag: tag)
      if tag.nil?
        return {:success?: false } #....
      end
    end

    tags.each do |tag|
      Tweet.db.create_text_tweet_tag(t.id, tag.id)
    end

    {
      :success? => true,
      :tweet => t,
      :tags => tags
    }
  end
end

## INSIDE TERMINAL CLIENT:

puts "What's your post:"
content = gets.chomp
puts "Give me a tag:"
tag = gets.chomp

result = PostTextTweet.new.run({
  content: "Look at my new Tweet!",
  tags: [tag]
})

if result[:success?]
  puts "You successfully posted this tweet"
  puts "Here is your tweet content: #{result[:tweet].content}"
else
  puts "You messed up. Here's why? #{result[:error]}"
end