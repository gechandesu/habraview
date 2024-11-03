module habr

import regex

pub fn get_id_from_url(url string) ?string {
	mut re := regex.regex_opt(r'/\d+/?$') or { return none }
	begin, end := re.find(url)
	if begin > 0 && end > 0 {
		return url[begin..end].trim('/')
	}
	return none
}
