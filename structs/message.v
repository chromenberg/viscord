module structs

import client {Client}

pub struct APIMessage {
pub:
	id         Snowflake
	channel_id Snowflake
	guild_id   Snowflake

	author  User
	content string

	timestamp string
	edited_at ?string @[json: edited_timestamp]

	tts bool

	mention_everyone bool
	mentions         []User
	mention_roles    []Role

	member Member
	channel_type ?int
	
	message_reference  ?MessageReference
	referenced_message ?&APIMessage
}

pub struct MessageReference {
	message_id ?Snowflake
	channel_id ?Snowflake
	guild_id   ?Snowflake
	fail_if_not_exists bool = true
	typ ?int @[skip, json: type]
}


// Defines the type of message that was sent
pub enum MessageType {
	default
	recipient_add
	recipient_remove
	call
	channel_name_change
	channel_icon_change
	channel_pinned_message
	user_join
	guild_boost
	guild_boost_tier_1
	guild_boost_tier_2
	guild_boost_tier_3
	channel_follow_add
	guild_discovery_disqualified
	guild_discovery_requalified
	guild_discovery_grace_period_initial_warning
	guild_discovery_grace_period_final_warning
	thread_created
	reply
	chat_input_command
	thread_starter_message
	guild_invite_reminder
	context_menu_command
	auto_moderation_action
	role_subscription_purchase
	interaction_premium_upsell
	stage_start
	stage_end
	stage_speaker
	stage_topic
	guild_application_premium_subscription
	guild_incident_alert_mode_enabled
	guild_incident_alert_mode_disabled
	guild_incident_report_raid
	guild_incident_report_false_alarm
	purchase_notification
	poll_result
}

@[flag]
pub enum MessageFlags {
	crossposted
	is_crosspost
	suppress_embeds
	source_message_deleted
	urgent
	has_thread
	ephemeral
	loading
	failed_to_mention_some_roles_in_thread
	noop1
	noop2
	noop3
	suppress_notifications
	is_voice_message
	has_snapshot
	is_components_v2 // needed to send components v2 messages
}
