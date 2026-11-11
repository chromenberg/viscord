module structs

pub struct APIUser {
pub:
	id 						 Snowflake
	username       string
	discriminator  string
	display_name  ?string @[json: global_name]
	avatar			  ?string
	
	// Partial according to discord, but when not present they arent a bot regardless
	bot 				   bool
	system			   bool

	mfa_enabled   ?bool
	banner			  ?string
	accent			  ?int    @[json: accent_color]
	locale        ?string
	verified      ?bool
	email			    ?string
	
	flags				  ?int
	premium_type  ?int
	public_flags  ?int

	avatar_deco   ?AvatarDeco @[json: avatar_decoration_data]
	collectibles  ?Collectible
	primary_guild ?GuildTag
}

// When a field is optional, it doesnt show up in the LSP autocomplete
pub struct User {
pub:
	id 						 Snowflake
	username       string
	discriminator  string
	display_name  ?string @[json: global_name]
	avatar			  ?string
	
	// Partial according to discord, but when not present they arent a bot regardless
	bot 				   bool
	system			   bool

	mfa_enabled   ?bool
	banner			  ?string
	accent			  ?int    @[json: accent_color]
	locale        ?string
	verified      ?bool
	email			    ?string
	
	flags				  ?int
	premium_type  ?int
	public_flags  ?int

	avatar_deco   ?AvatarDeco @[json: avatar_decoration_data]
	collectibles  ?Collectible
	primary_guild ?GuildTag
}

pub struct ClientUser {
	User
}

pub fn (u &User) avatar() {
}