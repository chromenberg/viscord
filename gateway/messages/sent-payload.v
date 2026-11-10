module messages

import events
import json2

@[omitempty]
pub struct SentPayload[T] {
	opcode events.EventOps    = none @[json: op]
	data   T	    						= none @[json: d]
	seq    int    						= none @[json: s]
	name   string 						= none @[json: t]
}

@[params]
pub struct PayloadOptions[T] {
pub:
	opcode events.EventOps
	data   T
	seq    int
	name   events.Events
}

// Base payload data for a message that is sent to discords servers
pub fn SentPayload.new[T](options PayloadOptions[T]) SentPayload[T] {
	return SentPayload[T]{
		opcode: options.opcode
		data:   options.data
		seq:    options.seq or {}
		name:   options.name.str().to_upper()
	}
}

// Encodes payload data into json string
pub fn (s &SentPayload[T]) encode() string {
	return json2.encode[SentPayload[T]](s)
}


