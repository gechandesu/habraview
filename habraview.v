module main

import cli
import habr
import os
import veb

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
}

struct Response {
	msg string
}

@[get]
fn (a &App) index(mut ctx Context) veb.Result {
	article_id := ctx.query['id'] or { habr.get_id_from_url(ctx.query['url']) or { '' } }
	client := habr.Habr.new()
	raw_article := client.get_article(article_id.int()) or {
		return ctx.json(Response{ msg: err.str() })
	}
	raw_comments := client.get_article_comments(article_id.int()) or {
		return ctx.json(Response{ msg: err.str() })
	}
	article := habr.Article.parse(raw_article)
	comments := habr.Comments.parse(raw_comments)
	return $veb.html()
}

fn runserver(port int) ! {
	os.chdir(os.dir(@FILE))!
	mut app := &App{}
	app.handle_static('assets', false)!
	app.serve_static('/favicon.ico', 'assets/favicon.ico')!
	veb.run[App, Context](mut app, port)
}

fn main() {
	mut app := cli.Command{
		name:        'habraview'
		description: 'Habr.com posts viewer.'
		version:     $d('habraview_version', '0.0.0')
		defaults:    struct {
			man: false
		}
		execute:     fn (cmd cli.Command) ! {
			port := cmd.flags.get_int('port') or { 8080 }
			runserver(port)!
		}
		flags:       [
			cli.Flag{
				flag:          .int
				name:          'port'
				abbrev:        'p'
				description:   'Listen port [default: 8888].'
				default_value: ['8888']
			},
		]
	}
	app.setup()
	app.parse(os.args)
}
