module handlers

import client {Client}
import gateway {Payload}
import gateway.messages as msg
import structs as types


pub fn guild_create(c &Client, p Payload[msg.GuildCreate])  {
	mut guild := types.Guild{}
	$for field in types.Guild.fields {
		guild.$(field.name) = &p.data.$(field.name)
	}
	// c.cache.guilds.set(p.data.id, guild)
	c.emit(.guild_create, &guild) 
	// The assembled guild object should have additional data like its channels
}