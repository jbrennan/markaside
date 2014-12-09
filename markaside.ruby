require 'redcarpet'


class Markaside < Redcarpet::Render::HTML
	def preprocess(text)
		asides(text)
	end
	
	def asides(message)
		# message.gsub! /({.*})/ do
		# 	"#{$1}<span class='aside'>#{$0}</span>"
		# end
		# message.gsub!(/({.*})/, "<span class=\"aside\">#{$0}.class</span>")
		message.gsub!(/{.*}/) do |w|
			aside = w.gsub("{", "").gsub("}", "") # yes, this is a crappy and slow way to do get rid of the braces, but I don't care. It works.
			"\\*<span class='aside'>\\* #{aside}</span>"
		end
		message
	end
end

if ARGV.length != 2
	puts "You must provide 2 arguments: the markdown filename and a title."
	exit
end

filename = ARGV.first
outname = ARGV[1]
body = File.read(filename)
render = Markaside.new
html = Redcarpet::Markdown.new(render).render(body)
smarty_html = Redcarpet::Render::SmartyPants.render html
output = 	"<!DOCTYPE html>"\
					"<html>"\
					"	<head>"\
					"<link href='http://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' rel='stylesheet' type='text/css'>"\
					"<meta charset='utf-8'>"\
					"<link href='markaside/style.css' media='screen' rel='stylesheet'><title>#{outname.capitalize}</title></head>"\
					"	<body><div class='content'>#{smarty_html}</div></body>"\
					"</html>"
File.open(outname + ".html", 'w') { |file|
	file.write(output)
}