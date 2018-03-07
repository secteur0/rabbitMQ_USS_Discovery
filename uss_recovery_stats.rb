#!/usr/bin/env ruby
require 'bunny'

connection = Bunny.new(hostname:  '172.17.0.2')
connection.start

channel = connection.create_channel
exchange = channel.direct('all')
queue = channel.queue('')

queue.bind(exchange, routing_key: 'recovery', exclusive: true)


begin
  puts ' [*] Waiting for messages from USS. To exit press CTRL+C'
  queue.subscribe(block: true) do |_delivery_info, _properties, body|
    p body
    # Make some statistics
  end
rescue Interrupt => _
  connection.close

  exit(0)
end