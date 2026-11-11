module builders

import structs {Snowflake}


// Base type for a discord mention in a message, this should not be constructable
@[noinit] 
struct BaseMention {
	prefix string
	id Snowflake
}

// Converts a mention into a string, this should not have to be overriden for 
// most implementations of a mention
pub fn (m &BaseMention) str() string {
	return "<${m.prefix}${m.id}>"
}

@[noinit]
pub type UserMention = BaseMention

@[noinit]
pub type ChannelMention = BaseMention

@[noinit]
pub type RoleMention = BaseMention

@[noinit]
pub type GameMention = BaseMention


pub fn UserMention.new(id Snowflake) BaseMention {
	return UserMention{
		prefix: "@"
		id: id
	}
}

pub fn ChannelMention.new(id Snowflake) BaseMention {
	return ChannelMention{
		prefix: "#"
		id: id
	}
}

pub fn RoleMention.new(id Snowflake) BaseMention {
	return RoleMention{
		prefix: "@&"
		id: id
	}
}

pub fn GameMention.new(id Snowflake) BaseMention {
	return GameMention{
		prefix: "@$"
		id: id
	}
}