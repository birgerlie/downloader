require "kafka"

class KafkaPublisher
  def initialize


  end


  def send
    producer = Kafka::Producer.new({ :topic=>'test', :host=>'datanode25.companybook.no' })
    message_number = 0

    while (true) do
      message = Kafka::Message.new("this is message number #{message_number}")
      producer.send(message)

      puts message.inspect

      message_number +=1
      sleep 1
    end
  end
end


KafkaPublisher.new.send

