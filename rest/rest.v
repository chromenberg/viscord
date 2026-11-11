module rest

import net.http
import json2

struct APIRequest {
	
}

pub struct API {
	token string
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

// Body should be a struct with a method that can convert a viscord type into a valid JSON structure
// by using the api types of them
pub fn (api &API) post[T](route string, body T) ! {
	data := http.post_json(base_url+route, body) or {
		return error("Failed to get data from ${base_url+route}")
	}

	return json2.decode[T](data.body) // Decode body into passed in type
}