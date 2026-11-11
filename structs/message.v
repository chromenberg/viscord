module structs

pub struct APIMessage {
pub:
	id               Snowflake
	channel_id       Snowflake
	
	author		       User
	content          string

	timestamp        string
	edited_at        ?string @[json: edited_timestamp]

	tts              bool

	mention_everyone bool
	mentions         []User
	mention_roles    []Role
}


pub struct Message {
pub:
	id               Snowflake
	channel_id       Snowflake
	channel          Channel
	
	author		       User
	content          string

	timestamp        string
	edited_at        ?string @[json: edited_timestamp]

	tts              bool
	
	mention_everyone bool
	mentions         []User
	mention_roles    []Role

}