require 'socket'
require 'avro'

MAIL_PROTOCOL_JSON = <<-EOS
{"namespace": "example.proto",
 "protocol": "Mail",

 "types": [
     {"name": "Message", "type": "record",
      "fields": [
          {"name": "to",   "type": "string"},
          {"name": "from", "type": "string"},
          {"name": "body", "type": "string"}
      ]
     }
 ],

 "messages": {
     "send": {
         "request": [{"name": "message", "type": "Message"}],
         "response": "string"
     },
     "replay": {
         "request": [],
         "response": "string"
     }
 }
}
EOS

MAIL_PROTOCOL = Avro::Protocol.parse(MAIL_PROTOCOL_JSON)

class MailResponder < Avro::IPC::Responder
  def initialize
    super(MAIL_PROTOCOL)
  end

  def call(message, request)
    if message.name == 'send'
      request_content = request['message']
      "Sent message to #{request_content['to']} from #{request_content['from']} with body #{request_content['body']}"
    elsif message.name == 'replay'
      'replay'
    end
  end
end

class RequestHandler
  def initialize(address, port)
    @ip_address = address
    @port = port
  end

  def run
    server = TCPServer.new(@ip_address, @port)
    while (session = server.accept)
      handle(session)
      session.close
    end
  end
end

class MailHandler < RequestHandler
  def handle(request)
    puts request.inspect
    responder = MailResponder.new()
    transport = Avro::IPC::SocketTransport.new(request)
    str = transport.read_framed_message
    transport.write_framed_message(responder.respond(str))
  end
end

if $0 == __FILE__
  handler = MailHandler.new('localhost', 9090)
  handler.run
end
