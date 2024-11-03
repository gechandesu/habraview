module habr

import json
import veb { RawHtml }

pub struct Article {
pub:
	published_at string  @[json: timePublished]
	title        string  @[json: titleHtml]
	text         RawHtml @[json: textHtml]
	hubs         []Hub
	tags         []Tag
}

pub fn Article.parse(input string) Article {
	return json.decode(Article, input) or { Article{} }
}

pub struct Hub {
pub:
	id    string
	alias string
	title string @[json: titleHtml]
}

pub struct Tag {
pub:
	title string @[json: titleHtml]
}

pub struct Comment {
pub:
	id          string
	parent_id   string   @[json: parentId]
	replies_ids []string @[json: children]
	level       int
	author      CommentAuthor
	message     RawHtml
}

pub struct CommentAuthor {
pub:
	alias string
}

struct CommentsMapped {
mut:
	items map[string]Comment @[json: comments]
}

pub struct Comments {
pub mut:
	items []Comment
mut:
	idx int
}

pub fn Comments.parse(input string) Comments {
	mut comments := Comments{}
	mapped := json.decode(CommentsMapped, input) or { CommentsMapped{} }
	for _, v in mapped.items {
		comments.items << v
	}
	return comments
}
