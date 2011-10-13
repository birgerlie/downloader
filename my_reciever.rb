require "kafka"
class MyReciever
  def initialize()

  end

  def listen()
    consumer = Kafka::Consumer.new({:host=>'datanode25.companybook.no',:topic=>'test', :partition=>0})
    consumer.loop do |messages|
      puts "Received"
      puts messages.inspect

    end
  end
end


MyReciever.new.listen