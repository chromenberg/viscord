module managers

import cache as c {Ttl}
import client {Client}
import structs as types {Snowflake, APIMessage}
import client.structures {Message, MessagePayload}
import time {Duration}
import rest
import json2

// We would need helper methods to get the user
// the user could be invalidated, which means we need to
// strip the user and member from the message
// when the message is being cached, and replace them
// with their ids

pub struct ChannelManager {
	cli ?&Client
pub:
	cache Ttl[Snowflake, types.Channel]
}

pub fn ChannelManager.new(cli &Client, ttl Duration) ChannelManager {
	return ChannelManager{
		cli: cli
		cache: c.new_ttl(ttl)
	}
}

type MessageData = MessagePayload

pub fn (man &ChannelManager) create_message(channel Snowflake, options MessagePayload) !Message {
	cli := man.cli or {panic("No client passed to channel manager")}
	res := cli.rest.post_message(channel, json2.encode[MessagePayload](options), [])
	api_msg := json2.decode[APIMessage](res) or {
		panic("message response, falied to make message")
	}

	msg := Message.new(cli, api_msg)
	// .set(msg.APIMessage.id, msg)
	return msg
}
