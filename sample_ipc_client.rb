require 'socket'
require 'avro'

MAIL_PROTOCOL_JSON = <<-JSON
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
JSON

MAIL_PROTOCOL = Avro::Protocol.parse(MAIL_PROTOCOL_JSON)

def make_requestor(server_address, port, protocol)
  sock = TCPSocket.new(server_address, port)
  client = Avro::IPC::SocketTransport.new(sock)
  Avro::IPC::Requestor.new(protocol, client)
end

if $0 == __FILE__
  #if ![3, 4].include?(ARGV.length)
  #  raise "Usage: <to> <from> <body> [<count>]"
  #end

  # client code - attach to the server and send a message
  # fill in the Message record
  message = {
    'to'   => "vincent",
    'from' => "birger",
    'body' => "foo bar"
  }

  num_messages = 10

  # build the parameters for the request
  params = {'message' => message}


  # send the requests and print the result
  num_messages.times do
    requestor = make_requestor('localhost', 9090, MAIL_PROTOCOL)
    result = requestor.request('send', params)
    puts("Result: " + result)
  end

  # try out a replay message
  requestor = make_requestor('localhost', 9090, MAIL_PROTOCOL)
  result = requestor.request('replay', {})

end
