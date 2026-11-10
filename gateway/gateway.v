module gateway

// TODO: This needs to be cleaned up and made more readable
// TODO: Give handlers their own system, event checking needs to be more thought out

import net.websocket
import rest
import json2
import messages
import events

//@[heap]
pub struct Gateway {
	eb    void // ? We could put the event bus here and all `on` calls from client are bound to this?
	token string
mut:
	sock websocket.Client
	seq  int
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

pub fn Gateway.new(tok string) Gateway {
	return Gateway{
		token: tok
	}
}

// Temporary message handler.
// TODO: Proper system to handle messages recieved and emit events to the event system
fn (mut self Gateway) message_handler(mut _ websocket.Client, msg &websocket.Message) ! {
	str := msg.payload.bytestr()
	data := Payload.new(str)

	println('New message with opcode: \n${data.opcode}')
	self.seq = data.seq

	if data.opcode == .hello {
		hello_payload := data.data as messages.Hello
		self.heart = Heartbeater.new(hello_payload.heartbeat_interval)
		self.heart.start(self)
	}
}

fn (mut self Gateway) close_handler(mut _ websocket.Client, code int, message string) ! {
	println('Connection closed with code: ${code} | Reason: ${message}')
	if code != 1000 || code != 1001 { // TODO: filter to only discord close codes
		self.heart.cancel()
	}
}

// Sends the identification payload to the gateway
fn (mut self Gateway) identify() {
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

pub fn (self &Gateway) send[T](payload T) ! {
	data := json2.encode[T](payload)
	self.sock.write_string(data)
}
