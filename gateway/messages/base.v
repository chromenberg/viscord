module messages

import events
import json2

@[omitempty]
pub struct SentPayload[T] {
	opcode int    = none @[json: op]
	data   T	    = none @[json: d]
	seq    int    = none @[json: s]
	name   string = none @[json: t]
}

@[params]
pub struct PayloadOptions[T] {
	opcode events.EventOps
	data   T
	seq    int
	name   events.Events
}

// Base payload data for a message that is sent to discords servers
pub fn SentPayload.new[T](options PayloadOptions) SentPayload[T] {
	return SentPayload[T]{
		opcode: options.opcode
		data:   options.data
		seq:    options.seq
		name:   options.name
	}
}

// Encodes payload data into json string
pub fn (s &SentPayload[T]) encode() string {
	return json2.encode[SentPayload[T]](s)
}


