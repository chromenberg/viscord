module managers

import cache as c {Ttl}
import structs as types
import time {Duration}

// We would need helper methods to get the user
// the user could be invalidated, which means we need to
// strip the user and member from the message
// when the message is being cached, and replace them
// with their ids

pub struct GuildManager {
pub:
	cache Ttl[types.Snowflake, types.Guild]
}

pub fn GuildManager.new(ttl Duration) GuildManager {
	return GuildManager{
		cache: c.new_ttl(ttl)
	}
}
