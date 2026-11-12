module structs

pub struct EmbedFooter {
pub mut:
	text           string
	icon_url       ?string // API handles this
	proxy_icon_url ?string // API handles this
}

pub struct EmbedImage {
pub mut:
	url          string
	proxy_url    ?string // handled automatically
	height       ?int    // Handled automatically
	width        ?int    // handled automatically
	content_type ?string // media type

	placeholder         ?string // blurred hash of theimage
	placeholder_version ?int
	description         ?string
	flags               ?int
}

pub struct EmbedProvider {
pub mut:
	name ?string
	url  ?string
}

pub struct EmbedAuthor {
pub mut:
	name           string
	url            ?string // author url
	icon_url       ?string // author image url
	proxy_icon_url ?string // handled automatically
}

pub struct EmbedField {
pub mut:
	name   string
	value  string
	inline ?bool // this can be an optional field but i want autocomplete
}

pub struct Embed {
	title       ?string
	type        ?EmbedType
	description ?string
	url         ?string
	timestamp   ?string
	color       ?int
}

pub type EmbedType

'rich' | 'image' | 'video' | 'gifv' | 'article' | 'link' | 'poll_result' | 'components'
