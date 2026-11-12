module managers

import cache as c {Ttl}
import structs as types
import client.structures {Message}
import time {Duration}

// We would need helper methods to get the user
// the user could be invalidated, which means we need to
// strip the user and member from the message
// when the message is being cached, and replace them
// with their ids

pub struct MessageManager {
pub:
	cache Ttl[types.Snowflake, Message]
}

pub fn MessageManager.new(ttl Duration) MessageManager {
	return MessageManager{
		cache: c.new_ttl(ttl)
	}
}
