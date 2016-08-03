require 'webrick'

# How we require another ruby script from our directory
require_relative 'database'

# Our global (yeah, yeah, I know I said never to use them) database
$database = Database.new

class HomePage < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    erb_template_string = File.read("homepage.html.erb")
    template = ERB.new(erb_template_string)
    output   = template.result(binding)

    response.body = output
    response.content_type = "text/html"
    response.status = 200
  end
end

class PromptToAddPerson < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    erb_template_string = File.read("prompt-to-add.html.erb")
    template = ERB.new(erb_template_string)
    output   = template.result(binding)

    response.body = output
    response.content_type = "text/html"
    response.status = 200
  end
end

class AddPerson < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    name = request.query["name"]
    phone_number = request.query["phone_number"]
    address = request.query["address"]
    position = request.query["position"]
    salary = request.query["salary"]
    slack_account = request.query["slack_account"]
    github_account = request.query["github_account"]

    person = $database.add(name, phone_number, address, position, salary, slack_account, github_account)

    erb_template_string = File.read("added.html.erb")
    template = ERB.new(erb_template_string)
    output   = template.result(binding)

    response.body = output
    response.content_type = "text/html"
    response.status = 200
  end
end

class PromptToSearchPerson < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    erb_template_string = File.read("prompt-to-search.html.erb")
    template = ERB.new(erb_template_string)
    output   = template.result(binding)

    response.body = output
    response.content_type = "text/html"
    response.status = 200
  end
end

class SearchPerson < WEBrick::HTTPServlet::AbstractServlet
  def do_GET(request, response)
    name = request.query["name"]# <<== replace this with getting the name from the request

    # Find the person (you figure out what method to call, some_method_here is wrong)
    person = $database.search(name)

    erb_template_string = File.read("search-result.html.erb")
    template = ERB.new(erb_template_string)
    output   = template.result(binding)

    response.body = output
    response.content_type = "text/html"
    response.status = 200
  end
end

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount "/", HomePage
server.mount "/prompt-to-add", PromptToAddPerson
server.mount "/add", AddPerson

server.mount "/prompt-to-search", PromptToSearchPerson
server.mount "/search", SearchPerson

# See if you can implement delete!!!
server.start
