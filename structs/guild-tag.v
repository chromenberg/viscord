module structs

pub struct GuildTag {
	guild_id ?Snowflake @[json: identity_guild_id]
	enabled  ?bool      @[json: identity_enabled]
	tag      ?string
	badge    ?string
}