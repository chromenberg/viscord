module structs

pub struct APIUnavailableGuild {
	id Snowflake
	unavailable bool = true
}

pub struct APIGuild {

}

pub struct Guild {
pub:
	id Snowflake
	owner_id Snowflake
	owner User
	members []Member // this should not store the full info, only the methods needed to get the info
pub mut:
	name string
	icon string
	banner string
}