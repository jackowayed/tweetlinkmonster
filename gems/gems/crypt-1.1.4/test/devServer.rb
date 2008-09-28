# run the crypt website

require 'webrick'
include WEBrick

serverConfig = {
  :Port => 80,
  :Logger => WEBrick::Log.new($stderr, WEBrick::Log::ERROR),
  :AccessLog => [[$stderr, WEBrick::AccessLog::COMBINED_LOG_FORMAT]]
}
server = WEBrick::HTTPServer.new(serverConfig)
server.mount("/", HTTPServlet::FileHandler, "C:/workspace/Crypt/site/", {:FancyIndexing => true})
server.mount("/crypt", HTTPServlet::FileHandler, "C:/workspace/Crypt/crypt/", {:FancyIndexing => true})

server.start

