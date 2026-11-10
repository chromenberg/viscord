module gateway

import json2
import events
import messages as msg

type AnyMessage = msg.Hello | msg.Heartbeat

// | msg.Ready | msg.Reconnect | msg.InvalidSession | msg.Resumed | msg.GuildCreate | msg.GuildUpdate | msg.GuildDelete | msg.GuildBanAdd | msg.GuildBanRemove | msg.GuildEmojisUpdate | msg.GuildStickersUpdate | msg.GuildIntegrationsUpdate | msg.GuildMemberAdd | msg.GuildMemberRemove | msg.GuildMemberUpdate | msg.GuildMembersChunk | msg.GuildRoleCreate | msg.GuildRoleUpdate | msg.GuildRoleDelete | msg.ChannelCreate | msg.ChannelUpdate | msg.ChannelDelete | msg.ChannelPinsUpdate | msg.ThreadCreate | msg.ThreadUpdate | msg.ThreadDelete | msg.ThreadListSync | msg.ThreadMemberUpdate | msg.ThreadMembersUpdate | msg.MessageCreate | msg.MessageUpdate | msg.MessageDelete | msg.MessageDeleteBulk

// Base payload of a gateway message, takes in struct T which is the data of the payload
// We cant decode the data until we have the event name
pub struct RawPayload {
pub:
	opcode events.EventOps @[json: op]

	// raw data of payload
	strdata string @[json: d]
	seq     int    @[json: s]
	// Name of the event as sent by the gateway
	strname string @[json: t]
mut:
	// decoded name of event used for creating the real payload
	name events.Events
}

@[omitempty]
pub struct Payload {
pub:
	opcode events.EventOps @[json: op]
	seq    int    @[json: s]	
pub mut:
	data AnyMessage	@[json: d]
	name events.Events @[json: t]
}

pub fn RawPayload.new(data string) RawPayload {
	mut json_data := json2.decode[RawPayload](data) or {
		panic('Failed to decode json data for ${data}')
	}

	if !json_data.strname.is_blank() {
		json_data.name = events.Events.from(json_data.strname.to_lower()) or {
			panic('No matching event')
		}
	}

	return json_data
}

pub fn (p RawPayload) decode[T]() T {
	return json2.decode[T](p.strdata) or {
		panic('Failed to decode payload data for ${p.opcode} | ${p.name}')
	}
}

pub fn Payload.new(data string) Payload {
	raw := RawPayload.new(data)
	mut payload := Payload{
		opcode: raw.opcode
		seq:    raw.seq
		name:   raw.name
	}

	payload.get_data(raw)

	return payload
}

fn (mut p Payload) get_data_from_named(raw RawPayload) {
	match raw.name {
		.ready {
			p.data = raw.decode[msg.Hello]()
		}
		else {}
	}
}

fn (mut p Payload) get_data(raw RawPayload) {
	match raw.opcode {
		.dispatch { p.get_data_from_named(raw) }
		.hello { p.data = raw.decode[msg.Hello]() }
	}
}
