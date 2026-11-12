module structures

import structs {APIMessage, Channel, User, Embed}
import client {Client}

// TODO: move these out from structs into structs client
pub struct Message {
	APIMessage
	cli 		?&Client
pub:
	referenced_message ?&Message
	channel Channel
}

pub fn Message.new(cli &Client, msg APIMessage) Message {
	return Message{
		msg
		cli: cli
	}
}

// This should return a PROMISE, this is async but i dont have this set up
// TODO: seamless async await system where the user doesnt have to do anything
pub fn (msg &Message) reply(opt MessageOptions) !Message {
	data := MessagePayload.new(msg, opt)
	cli := msg.cli or {panic("No message passed to client")}
	return cli.channels.create_message(msg.channel_id, data)
}

pub struct MessageOptions {
pub:
	content string
	embeds  ?[]Embed
}
