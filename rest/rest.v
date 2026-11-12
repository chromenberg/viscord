module rest

import net.http
import json2
import strings { new_builder }

struct APIRequest {
}

pub struct API {
pub mut:
	token string = "no token"
}

// Fixed API version for now
const base_url = 'https://discord.com/api/v10'

fn (api &API) fetch(method http.Method, route string, data ?string, mime ?string) !http.Response {
	return http.fetch(
		url:    base_url + route
		method: method
		header: api.headers(mime)
		data:   data or {""}
	)
}

fn (api &API) headers(mime ?string) http.Header {
	return http.new_header_from_map({
		http.CommonHeader.content_type:  mime or { 'application/json' }
		http.CommonHeader.authorization: 'Bot ' + api.token
		http.CommonHeader.user_agent:    'viscord (PRIVATE_URL, 0.0.alpha)'
	})
}

// Gets data from a url and returns type T
//
// Useful for wanting to return a specific data type
// from an endpoint
//
// Specified type must follow V json syntax
pub fn (api &API) get[T](route string) !T {
	data := api.fetch(.get, route, none, none) or {
		return error('Failed to get data from ${base_url + route}')
	}

	return json2.decode[T](data.body) // Decode body into passed in type
}

// Body should be a struct with a method that can convert a viscord type into a valid JSON structure
// by using the api types of them
pub fn (api &API) post[T](route string, body T) ! {
	data := http.post_json(base_url + route, body) or {
		return error('Failed to get data from ${base_url + route}')
	}

	return json2.decode[T](data.body) // Decode body into passed in type
}

fn (api &API) handle_error(res http.Response) !http.Response {
	// TODO: This needs to go through the status code and see if it errored
	// TODO: if it did then program needs to crash depending on what error it was

	return res
}

// Queues a request into the APIs thread event loop,
// so the main thread doesnt get blocked
pub fn (api &API) queue_request() {}

// TODO: This should just be part of POST, GET, PUT, PATCH, DELETE (ROUTE, DATA)
pub fn (api &API) post_message(channel_id string, data string, files []http.FileData) string {
	formdata, boundary := form_body(data, files)
	println("${formdata}\n${boundary}")
	res := api.fetch(
		.post,
		message_channel_url(channel_id),
		formdata
		'multipart/form-data; boundary=${boundary}',
	) or {
		panic("message send failed for some reason")}

	return res.body
}

// import rand

// Function by deepseek, vlang does not have its own multipart form custom thing
// i could have made this myself, but i might be a bit stupid and didnt realise that at the moment
fn form_body(payload_json string, files []http.FileData) (string, string) {
	boundary := 'viscord' /* + rand.ulid() */
	mut sb := strings.new_builder(1024)

	sb.write_string('--${boundary}\r\n')
	sb.write_string('Content-Disposition: form-data; name="payload_json"\r\n')
	sb.write_string('Content-Type: application/json\r\n\r\n')
	sb.write_string(payload_json)
	sb.write_string('\r\n')

	for i, f in files {
		sb.write_string('--${boundary}\r\n')
		sb.write_string('Content-Disposition: form-data; name="files[${i}]"; filename="${f.filename.replace('"', '')}"\r\n')
		sb.write_string('Content-Type: ${f.content_type}\r\n\r\n')
		sb.write_string(f.data)
		sb.write_string('\r\n')
	}

	sb.write_string('--${boundary}--\r\n')
	return sb.str(), boundary
}
