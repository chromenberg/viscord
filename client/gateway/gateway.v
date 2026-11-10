module gateway

// TODO: This needs to be cleaned up and made more readable
// TODO: Give handlers their own system, event checking needs to be more thought out

import net.websocket
import rest
import json2
import messages { SentPayload, Identify }
import events
import eventbus

enum GatewayState {
	connecting
	connected
	ready
}

//@[heap]
pub struct Gateway {
	eb      &eventbus.EventBus[events.Events] = eventbus.new[events.Events]() // ? We could put the event bus here and all `on` calls from client are bound to this?
	token   string
	intents int
mut:
	state GatewayState = .connecting
	sock  websocket.Client
	seq   int
	heart Heartbeater
}

pub struct GatewayURLReq {
	url string @[required]
}

fn get_socket_url() ?string {
	data := rest.get[GatewayURLReq]('/gateway') or {
		eprintln('No data was recieved from gateway url endpoint')
		return none
	}

	return data.url
}

pub fn Gateway.new(tok string, intents int) Gateway {
	return Gateway{
		token:   tok
		intents: intents
	}
}

// Temporary message handler.
// TODO: Proper system to handle messages recieved and emit events to the event system
fn (mut self Gateway) message_handler(mut _ websocket.Client, msg &websocket.Message) ! {
	str := msg.payload.bytestr()
	data := Payload.new(str)

	if data.seq != 0 {self.seq = data.seq}
	println('New message with opcode: ${data.opcode}\nSeq: ${self.seq} | Event Name: ${data.name}')

	if data.opcode == .hello {
		
	}

	match data.opcode {
		.dispatch {
			self.handle_dispatch(data)
		}

		.hello {
			hello_payload := data.data as messages.Hello
			self.heart = Heartbeater.new(hello_payload.heartbeat_interval)
			self.heart.start(self)
			self.identify()
		}
	}
}

fn (mut self Gateway) close_handler(mut _ websocket.Client, code int, message string) ! {
	println('Connection closed with code: ${code} | Reason: ${message}')
	if self.heart.state == .running { // TODO: filter to only discord close codes
		self.heart.cancel()
	}
}

// Sends the identification payload to the gateway
fn (mut self Gateway) identify() {
	data := Identify.new(
		token: self.token, 
		intents: self.intents
	)
	self.send[Identify](data) or {
		panic("Couldnt identify. TODO: Retry identify instead of crash")
	}
}

pub fn (mut self Gateway) connect() ! {
	url := get_socket_url() or {
		panic('No gateway URL was recieved')
	}

	self.sock = websocket.new_client(url)!
	self.sock.connect()!
	self.sock.on_message(self.message_handler)
	self.sock.on_close(self.close_handler)
	mut sock := &self.sock

	// the program lingers here for the lifecycle of the connection
	// other parts of the program are called from the event system
	sock.listen()!

	// TODO: cleanup function that removes all structs when closed
	// TODO: Cant do this with heartbeat because that references gateway
	// TODO: and not the other way around

	return
}

pub fn (self &Gateway) send[T](payload SentPayload[T]) ! {
	self.sock.write_string(payload.encode())
}

pub fn (self &Gateway) emit[T](name events.Events, data T) {
	self.eb.publish(name, self, data)
}

pub fn (self &Gateway) handle_dispatch(data Payload) {
	match data.name {
		.message_create {}
		.message_delete {}
	}
}