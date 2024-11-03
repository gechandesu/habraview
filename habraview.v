module main

import cli
import habr
import net
import net.urllib
import net.http.mime
import os
import veb

pub struct Context {
	veb.Context
}

pub struct App {}

const embedded = {
	'style.css':         $embed_file('assets/style.css')
	'highlight.min.css': $embed_file('assets/highlight.min.css')
	'highlight.min.js':  $embed_file('assets/highlight.min.js')
	'habrfixer.js':      $embed_file('assets/habrfixer.js')
	'favicon.ico':       $embed_file('assets/favicon.ico')
}

@['/assets/:filename']
fn (a &App) assets(mut ctx Context, filename string) veb.Result {
	asset := embedded[filename] or { return ctx.not_found() }
	mimetype := mime.get_mime_type(os.file_ext(filename).trim_left('.'))
	ctx.set_content_type(mimetype)
	return ctx.text(asset.to_string())
}

@[get]
fn (a &App) index(mut ctx Context) veb.Result {
	article_id := ctx.query['id'] or { habr.get_id_from_url(ctx.query['url']) or { '' } }
	client := habr.Habr.new()
	raw_article := client.get_article(article_id.int()) or { return ctx.server_error(err.str()) }
	raw_comments := client.get_article_comments(article_id.int()) or {
		return ctx.server_error(err.str())
	}
	article := habr.Article.parse(raw_article)
	comments := habr.Comments.parse(raw_comments)
	return $veb.html()
}

fn serve(host string, port int) ! {
	mut app := &App{}
	mut ipversion := net.AddrFamily.ip
	if host.contains(':') {
		ipversion = net.AddrFamily.ip6
	}
	params := veb.RunParams{
		host:   host
		port:   port
		family: ipversion
	}
	veb.run_at[App, Context](mut app, params)!
}

fn run_server(cmd cli.Command) ! {
	mut host, mut port := '0.0.0.0', '8888'
	if cmd.args.len == 1 {
		host, port = urllib.split_host_port(cmd.args[0])
		if host.is_blank() {
			host = '0.0.0.0'
		}
		if port.is_blank() {
			port = '8888'
		}
	}
	serve(host, port.int())!
}

fn main() {
	mut app := cli.Command{
		name:        'habraview'
		usage:       '[host][:port]'
		description: 'Habr.com posts viewer.'
		version:     $d('habraview_version', '0.0.0')
		defaults:    struct {
			man: false
		}
		execute:     run_server
	}
	app.setup()
	app.parse(os.args)
}
