require "kemal"

get "/api" do
  "Hello World!"
end

Kemal.config.port = 4000
Kemal.run
