module client

import gateway as gt
import events
import managers as man
import time { Duration }
import eventbus {EventBus}
import rest as api

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
	emitter &EventBus[events.Events] = EventBus.new[events.Events]() // ? We could put the event bus here and all `on` calls from client are bound to this?
pub mut:
	channels man.ChannelManager
	guilds   man.GuildManager
	messages man.MessageManager
	rest api.API
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
	mut cli := &Client{
		intents: opt.intents
		rest: api.API{}
	}
	cli.channels = ChannelManager.new(cli, opt.cache.ttl)
	cli.guilds = GuildManager.new(opt.cache.ttl)
	cli.messages = MessageManager.new(opt.cache.ttl)

	println('Intents: ${opt.intents}')
	return cli
}

pub fn (mut c Client) login(token string) ! {
	c.rest.token = token
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
