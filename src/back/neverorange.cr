require "kemal"
require "crest"
require "xml"
require "json"

# struct ProjectStatus
#   property name, activity, lastBuildStatus

#   def initialize(@name : String, @activity : String, @lastBuildStatus : String)
#   end
# end

struct ProjectStatus
  JSON.mapping({
    name: String,
    activity: String,
    lastBuildStatus: String,
  })

  def initialize(@name : (String)?, @activity : (String)?, @lastBuildStatus : (String)?)
  end
end

get "/api/status" do |env|
  target = env.params.query["target"]?
  if !target
    halt env, status_code: 400, response: "'target' parameter is required"
  end
  
  response = Crest.get(target, handle_errors: false)
  if !(response.status_code == 200)
    halt env, status_code: response.status_code
  end

  doc = XML.parse(response.body)

  statuses = { projects: [] of ProjectStatus}
  doc.children[0].children.each do |child|
    project_status = ProjectStatus.new(child["name"], child["activity"], child["lastBuildStatus"])
    statuses["projects"] << project_status
  end

  env.response.content_type = "application/json"
  statuses.to_json
end

Kemal.config.port = 4000
Kemal.run
