module messages
import structs as types

pub struct MessageCreate {
	types.Message
pub:
	guild_id types.Snowflake
	member types.Member
	?channel_type int
}

