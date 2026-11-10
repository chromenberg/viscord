module structs

pub struct Nameplate {
	sku_id Snowflake
	asset string
	label string
	palette string
}

pub struct Collectible {
	?nameplate Nameplate
}