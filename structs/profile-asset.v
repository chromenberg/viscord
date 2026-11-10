module structs 

pub struct Asset[T] {
	asset string
	sku_id Snowflake
	_ ...T
}