module handlers

import client {Client}
import gateway {Payload}
import gateway.messages as msg
import client.structures {Message}

pub fn message_create(c &Client, p Payload[msg.MessageCreate]) {
	mut message := Message.new(c, p.data)
	// c.cache.messages.set(p.data.id, message)
	c.emit(.message_create, &message)
	// event_data := payload.data as msg.MessageCreate
}