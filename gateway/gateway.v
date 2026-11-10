module gateway

import net.websocket
import rest
import json2
import messages

//@[heap]
pub struct Gateway {
	eb    void // ? We could put the event bus here and all `on` calls from client are bound to this?
	token string
mut:
	sock websocket.Client
	seq  int
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
			mut heart := Heartbeater.new(self, hello_payload.heartbeat_interval)
			heart.start()
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
