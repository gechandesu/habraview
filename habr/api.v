module habr

import net.http

pub struct Habr {
	baseurl string = $d('habr_baseurl', 'https://habr.com')
}

pub fn Habr.new() Habr {
	return Habr{}
}

pub fn (h Habr) get_article(id int) !string {
	response := http.get('${h.baseurl}/kek/v2/articles/${id}/') or { return err }
	return response.body
}

pub fn (h Habr) get_article_comments(id int) !string {
	response := http.get('${h.baseurl}/kek/v2/articles/${id}/comments/') or { return err }
	return response.body
}
