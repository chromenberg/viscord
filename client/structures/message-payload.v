module structures

// import client {Client}
import structs {Embed, MessageReference}

pub struct MessagePayload {
pub mut:
	content           string
	embeds            ?[]Embed
	message_reference ?MessageReference
	username          ?string
}

pub fn MessagePayload.new(target &Message, opts MessageOptions, extra ?MessagePayload) MessagePayload {
	mut payload := MessagePayload{
		content: opts.content
		embeds: opts.embeds
		message_reference: MessageReference{
			message_id: target.id
			channel_id: target.channel_id
			guild_id: target.guild_id
		}
	}
	if e := extra {
		payload.content = e.content
		payload.embeds = e.embeds
		payload.username = e.username
	}
	return payload
}
