require "kemal"
require "crest"
require "xml"
require "json"

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

  statuses = doc.children[0].children.map do |child|
    ProjectStatus.new(
      name: child["name"],
      activity: child["activity"],
      lastBuildStatus: child["lastBuildStatus"])
  end

  env.response.content_type = "application/json"
  statuses.to_json
end

Kemal.config.port = 4000
Kemal.run
