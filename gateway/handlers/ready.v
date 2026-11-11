module handlers

import client { Client }
import gateway { Payload }
import gateway.messages as msg
import structs as types

pub fn ready(c &Client, p Payload[msg.Ready]) {
	// We need to tell the client we expect x amount of guild create events
	// We need to cache the `bot` field
	// We need to convert the application api payload into an application struct
	// 	for having methods and readability

	// When emitting an event, the data MUST be the constructed object,
	// so message will have all of its proper channel attributes instead of just `channel_id`

	println('[Handlers:Ready] Expecting ${p.data.guilds.len} GUILD_CREATE events')
	c.emit(.ready, &p.data)
}
