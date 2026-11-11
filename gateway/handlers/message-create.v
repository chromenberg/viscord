module handlers

import client {Client}
import gateway {Payload}
import gateway.messages as msg
import structs as types

pub fn message_create(c &Client, p Payload[msg.MessageCreate]) {
	mut message := types.Message{}
	$for field in types.Message.fields {
		message.$(field.name) = &p.data.$(field.name)
	}
	c.cache.messages.set(p.data.id, message)
	c.emit(.message_create, &message)
	// event_data := payload.data as msg.MessageCreate
}