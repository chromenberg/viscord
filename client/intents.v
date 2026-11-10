module client

@[flag]
pub enum GatewayIntentBits as u64 {
	guilds
	guild_members
	guild_moderation
	guild_expressions
	guild_integrations
	guild_webhooks
	guild_invites
	guild_voice_states
	guild_presences
	guild_messages
	guild_message_reactions
	guild_message_typing
	direct_messages
	direct_message_reactions
	direct_message_typing
	message_content
	guild_scheduled_events
	automod_config
	automod_execution
	guild_message_polls
	direct_message_polls
}

// `bits` is the value of every intent bit
pub fn GatewayIntentBits.intents(bits []GatewayIntentBits) int {
	mut result := 0
	for bit in bits  {
		result |= int(bit)
	}
	return result
}