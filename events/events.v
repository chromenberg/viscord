module events

// This module contains the names of all the events
// that can be send / recieved from gateway

@[json_as_number]
pub enum EventOps {
	dispatch
	heartbeat         // sent and recieved by server
	identify          // [sent] This is sent to the server
	upd_presence      // [sent] Update the clients presence
	upd_voice_state   // [sent] Join / Leave / Move between voice
	resume = 6            // [sent] Resume previous session
	reconnect         // Attempt to reconnect and resume
	req_guild_members // [sent] Get info of offline members in large guild
	invalid_session   // Session invalid, reidentify and reconnect
	hello             // Sent after connecting, start heartbeat
	heartbeat_ack
	req_soundboard
	req_channel_info
}

@[json_as_number]
pub enum CloseCodes {
	unknown_error = 4000
	unknown_opcode
	decode_error
	not_authed
	auth_failed
	already_authed
	invalid_seq
	rate_limited
	timed_out
	invalid_shard
	shard_required
	invalid_api_version
	invalid_intents
	disallowed_intents
}

// JSON needs to emit this as an uppercase form of its name
pub enum Events {
	unknown
	hello
	ready
	resumed
	reconnect
	rate_limited
	invalid_session
	application_command_permissions_update
	auto_moderation_rule_create
	auto_moderation_rule_update
	auto_moderation_rule_delete
	auto_moderation_action_execution

	channel_create
	channel_update
	channel_delete
	channel_info
	channel_pins_update

	thread_create
	thread_update
	thread_delete
	thread_list_sync // sent when gaining access to channel, has all active threads
	thread_member_update
	thread_members_update

	entitlement_create
	entitlement_update
	entitlement_delete

	guild_create // Lazy-load unavailable, guild became available, or joined new guild
	guild_update
	guild_delete // Guild unavailable, or user left/was removed
	guild_audit_log_entry_create
	guild_ban_add
	guild_ban_remove
	guild_emojis_update
	guild_stickers_update
	guild_integrations_update

	guild_member_add
	guild_member_removed
	guild_member_update
	guild_members_chunk

	guild_role_create
	guild_role_update
	guild_role_delete

	guild_scheduled_event_create
	guild_scheduled_event_update
	guild_scheduled_event_delete
	guild_scheduled_event_user_add
	guild_scheduled_event_user_delete

	guild_soundboard_sound_create
	guild_soundboard_sound_update
	guild_soundboard_sound_delete
	guild_soundboard_sounds_update

	integration_create
	integration_update
	integration_delete
	
	interaction_create
	
	invite_create
	invite_delete

	message_create
	message_update
	message_delete
	message_delete_bulk
	
	message_reaction_add
	message_reaction_remove
	message_reaction_remove_all
	message_reaction_remove_emoji

	presence_update
}
