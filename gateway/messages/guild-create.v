module messages

import structs as types

pub struct GuildCreate {
	types.APIGuild
pub:
	joined_at     string
	large         bool
	unvailable    bool
	member_count  int
	// voice_states  void

	members  			[]types.APIMember
	channels 			[]types.APIChannel
	threads  			[]types.APIChannel

	// presences              void
	// stage_instances        void
	// guild_scheduled_events void
	// soundboard_sounds      void
}