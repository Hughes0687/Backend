require 'unirest'

response = Unirest.get('http://makerblog.herokuapp.com/posts',
  headers: { "Accept" => "application/json" })

module MakerBlog
  class Client
    def list_posts
      response = Unirest.get('http://makerblog.herokuapp.com/posts',
        headers: { "Accept" => "application/json" })
      posts = response.body
      posts.each do |post|
        puts post["name"]
        puts post["title"]
        puts post["content"]
        puts 
      end
    end

    def show_post(id)
  # hint: URLs are strings and you'll need to append the ID
      url = "http://makerblog.herokuapp.com/posts"

      response = Unirest.get('http://makerblog.herokuapp.com/posts',
      headers: { "Accept" => "application/json" })
      posts = response.body
      puts posts.find {|p| p["id"] == id}
     
    end

    def create_post(name, title, content)
      url = "http://makerblog.herokuapp.com/posts"
      payload = {:post => {'name' => name, 'title' => title, 'content' => content}}

      response = Unirest.post('http://makerblog.herokuapp.com/posts',
        headers: { "Accept" => "application/json",
                   "Content-Type" => "application/json" },
        parameters: payload)

      # convert then display your results here
    end

    def edit_post(id, options = {})
      url = 'http://makerblog.herokuapp.com/posts/' + id.to_s
      params = {}

      params[:name] = options[:name] unless options[:name].nil?
      params[:title] = options[:title] unless options[:title].nil?
      params[:content] = options[:content] unless options[:content].nil?

      response = Unirest.put(url,
        parameters: { :post => params},
        headers: { "Accept" => "application/json",
          "Content-Type" => "application/json"})

        edited = response.body
        puts "Edit: #{edited["id"]}"
    end

    def delete_post(id)
      url = 'http://makerblog.herokuapp.com/posts/' + id.to_s
      response = Unirest.delete(url,
        headers: { "Accept" => "application/json"})
      puts response.code
  
  
    deleted = response.body
    puts "Deleted: #{deleted["id"]}"
    end  

  end
end

client = MakerBlog::Client.new
# client.delete_post(19089)

client.edit_post(19021, {:name => "Snake Plisssskendfgadfgasfgadfgadf", :content => "Escape from LAsfgasfgasfgadfgadfg"})