module rest

import net.http
import json2

struct APIRequest {
	
}

// Fixed API version for now
const base_url = "https://discord.com/api/v10"

// Gets data from a url and returns type T
//
// Useful for wanting to return a specific data type
// from an endpoint
//
// Specified type must follow V json syntax
pub fn get[T](route string) !T {
	data := http.get(base_url+route) or {
		return error("Failed to get data from ${base_url+route}")
	}

	return json2.decode[T](data.body) // Decode body into passed in type
}