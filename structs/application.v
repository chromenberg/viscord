module structs

pub struct APIApplication {
pub:
	id 																		Snowflake
	name 																	string
	icon 																	?string
	description 													string

	rpc_origins 													?[]string

	bot_public 														bool
	bot_require_code_grant 								bool
	
	bot 																	APIUser
	owner 																?User

	terms_of_service_url 									?string
	privacy_policy_url 										?string

	verify_key 														string
	team 																	void @[skip]

	guild_id 															?Snowflake
	guild 																?APIGuild

	primary_sku_id 												?Snowflake
	slug 																	?string

	cover_image 													?string
	flags 																?int // legacy
	flags_new 														?string // current

	approximate_guild_count 							?int
	approximate_user_install_count 				?int
	approximate_user_authorization_count 	?int

	redirect_uris 												?[]string
	interactions_endpoint_url 						?string
	role_connections_verification_url 		?string
	event_webhooks_url 										?string
	event_webhooks_status 								?EventWebhookStatus
	event_webhooks_types 									?[]string
	tags  																?[]string
	install_params           							?InstallParams
	integration_types_config 							void @[skip] // dictionary indexed by install type, value is integration permissions
	custom_install_url       							?string
}

pub enum EventWebhookStatus {
	disabled = 1
	enabled
	disabled_by_discord
}

pub struct InstallParams {

}