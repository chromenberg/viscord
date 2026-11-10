module client

import gateway as gt
import events

pub struct Client {
mut:
	ws gt.Gateway  // Connection to gateway is established after #login called
}

struct ClientOpts {
	intents GatewayIntentBits
}

pub fn Client.new(opt ?ClientOpts) Client {
	return Client{}
}

pub fn (mut c Client) login(token string) ! {
	c.ws = gt.Gateway.new(token)
	c.ws.connect()!

	return
}

pub fn (mut c Client) on(event events.Events, cb events.EventFn) {
	events.on_event(event, cb)
}
