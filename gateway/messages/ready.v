module messages

import structs as types

pub struct Ready {
pub:
	user types.APIUser // contains the user info for this bot, but application also does aswell
	guilds []types.APIUnavailableGuild

	session_id string
	resume_url string @[json: resume_gateway_url]
	
	?shard [2]int

	application types.APIApplication
}