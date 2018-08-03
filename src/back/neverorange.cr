require "kemal"

get "/" do
  "Hello World!"
end

Kemal.config.port = 4000
Kemal.run
