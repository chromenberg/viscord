module client

import gateway as gt
import events

pub struct Client {
	intents int
mut:
	ws gt.Gateway  // Connection to gateway is established after #login called
}

@[params]
pub struct ClientOpts {
	pub intents int
}

pub fn Client.new(opt ClientOpts) Client {
	if opt.intents == 0 {eprintln("Client Intents have no value! Did you set the client intents?")}
	println("Intents: ${opt.intents}")
	return Client{
		intents: opt.intents
	}
}

pub fn (mut c Client) login(token string) ! {
	c.ws = gt.Gateway.new(token c.intents)
	c.ws.connect()!

	return
}

pub fn (mut c Client) on(event events.Events, cb events.EventFn) {
	events.on_event(event, cb)
}
