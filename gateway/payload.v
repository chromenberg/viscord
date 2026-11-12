module gateway

import json2
import events
import messages as msg

type AnyMessage = msg.Hello | msg.Heartbeat | msg.MessageCreate

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
pub struct Payload[T] {
pub:
	opcode events.EventOps @[json: op]
	seq    int    @[json: s]	
pub mut:
	data T	@[json: d]
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
		panic('Failed to decode payload data for ${p.opcode} | ${p.name} ${p.strdata}')
	}
}

pub fn Payload.new[T](raw RawPayload) Payload[T] {
	mut payload := Payload{
		opcode: raw.opcode
		seq:    raw.seq
		data:   raw.decode[T]()
		name:   raw.name
	}

	return payload
}
