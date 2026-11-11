module client

import gateway as gt
import events
import store { ClientCache }
import time { Duration }
import eventbus {EventBus}

pub struct Event[T] {
	T // Embed the data of the event or use the new/old
pub mut:
	new T
	old T
}

pub struct Client {
	intents int
mut:
	ws gt.Gateway // Connection to gateway is established after #login called
pub:
	cache   &ClientCache
	emitter &EventBus[events.Events] = EventBus.new[events.Events]() // ? We could put the event bus here and all `on` calls from client are bound to this?
}

@[params]
pub struct ClientOpts {
pub:
	intents int
	cache struct {
		ttl Duration
	}
}

pub fn Client.new(opt ClientOpts) &Client {
	if opt.intents == 0 {
		eprintln('Client Intents have no value! Did you set the client intents?')
	}
	println('Intents: ${opt.intents}')
	return &Client{
		intents: opt.intents
		cache: ClientCache.new(opt.cache.ttl)
	}
}

pub fn (mut c Client) login(token string) ! {
	c.ws = gt.Gateway.new(token, c.intents)

	c.ws.connect(&c)!

	return
}

pub fn (c &Client) emit(name events.Events, data voidptr) {
	c.emitter.publish(name, data, data)
}

type OnFn = fn (data voidptr)

pub fn (c &Client) on(name events.Events, cb OnFn) {
	mut sub := c.emitter.subscriber
	sub.subscribe(name, fn [cb] (reciever voidptr, args voidptr, sender voidptr) {
		cb(args)
	})
}


// pub fn (mut c Client) on(event events.Events, cb events.EventFn) {
// 	events.on_event(event, cb)
// }
