module client

@[flag]
pub enum GatewayIntentBits {
	guilds
	guild_members
	guild_moderation
	guild_expressions
	guild_integrations
	guild_webhooks
	guild_invites
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
