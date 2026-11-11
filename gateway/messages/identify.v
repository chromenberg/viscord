module messages

import os 
import events

pub struct Identify {
	token string
	intents int
	properties struct {
		system  string = os.user_os() @[json: os]
		browser string = "viscord"
		device  string = "viscord"
	}
}

@[params]
pub struct IdentifyData {
pub:
	token string
	intents int
}

// Creates a new `Identify` payload, returns the data wrapped in the payload ready to send to the server
pub fn Identify.new(opts IdentifyData) SentPayload[Identify] {
	return SentPayload.new[Identify](
		opcode: events.EventOps.identify
		data: Identify{
			token:   opts.token
			intents: opts.intents
		}
	)
}