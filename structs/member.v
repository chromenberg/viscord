module structs

// Partial data for a member, all optional fields are fields discord may or may not send to the client
pub struct APIMember {
pub:
	// If the event is messagecreate / update, user is not present
	// otherwise when this is present, the user is always there
	user ?User
	nick ?string

	avatar ?string
	banner ?string

	roles []Snowflake
	
	joined_at ?string // ISO8601 timestamp
	premium_since ?string

	deaf bool
	mute bool
	flags int // guild member flags as bitset

	pending ?bool
	// Permissions of the member in the channel, including overrides.
	// Returned in the interaction object
	permissions ?string
	communication_disabled_until ?string // timed out until
	avatar_deco ?AvatarDeco @[json: avatar_decoration_data]
	collectibles ?Collectible
}

// Partial data for a member, all optional fields are fields discord may or may not send to the client
pub struct Member {
pub:
	// If the event is messagecreate / update, user is not present
	// otherwise when this is present, the user is always there
	user ?User
	nick ?string

	avatar ?string
	banner ?string

	roles []Snowflake
	
	joined_at ?string // ISO8601 timestamp
	premium_since ?string

	deaf bool
	mute bool
	flags int // guild member flags as bitset

	pending ?bool
	// Permissions of the member in the channel, including overrides.
	// Returned in the interaction object
	permissions ?string
	communication_disabled_until ?string // timed out until
	avatar_deco ?AvatarDeco @[json: avatar_decoration_data]
	collectibles ?Collectible
}