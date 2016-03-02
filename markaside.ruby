require 'redcarpet'
require 'json'
require 'erb'

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
			"<span class='asterisk'>\\*</span><span class='aside'><span class='asterisk'>\\* </span>#{aside}</span>"
		end
		message
	end
end

# Helper methods. They're defined at the top becuase ruby can't do out of order methods???

def generate_blank_config(filename)
	# markdown filename, output path + filename, html title
	config = {
		markdown_filename: "path/to/markdown.md",
		output_filename: "path/to/index.html",
		html_title: "I want this to be my title"
	}
	
	File.open(filename, 'w') { |file|
		file.write(JSON.pretty_generate(config))
	}
end

# Reads in the config file and returns it as a hash.
# Or, creates a json file and exits.
def read_or_make_config(filename)
	begin
		f = File.read(filename)
		config = JSON.parse(f)
		
		return config
		
	rescue Exception => e
		puts "No " + filename + " in the current directory, generating a blank one."
		generate_blank_config(filename)
		puts "Saved. Edit #{filename} and re-run markaside."
		
		exit
	end
end

# Look for a markaside.json in the current directory and use that for config if found
# if it's not found, generate one and tell to edit that first.

config_filename = "markaside.json"
config = read_or_make_config(config_filename)

# Now generate the output stuff

filename = config["markdown_filename"]
outname = config["output_filename"]
title = config["html_title"]

# I know these configs aren't elegant, it's a hack for now!
extra_css = config["extra_css"]
if extra_css != nil
	extra_css = "<link href='#{extra_css}' media='screen' rel='stylesheet'>"
else
	extra_css = ""
end

# get a specific header, if it exists
header = config["header"]
if header != nil
	header = ERB.new(File.read(header)).result()
else
	header = ""
end

# get a specific footer, if it exists
footer = config["footer"]
if footer != nil
	footer = ERB.new(File.read(footer)).result()
else
	footer = ""
end

body = File.read(filename)

render = Markaside.new
html = Redcarpet::Markdown.new(render).render(body)
smarty_html = Redcarpet::Render::SmartyPants.render html

# todo: use ERB or something for this template
output = 	"<!DOCTYPE html>"\
					"<html lang='en'>"\
					"	<head>"\
					"<link href='http://fonts.googleapis.com/css?family=Lora:400,700,400italic,700italic' rel='stylesheet' type='text/css'>"\
					"<meta charset='utf-8'>"\
					"<meta name='viewport' content='width=device-width'>"\
					"<link href='markaside/style.css' media='screen' rel='stylesheet'>"\
					"#{extra_css}"\
					"<title>#{title}</title></head>"\
					"	<body>#{header}<section class='main_col'><div class='content'>#{smarty_html}</div></section>#{footer}</body>"\
					"</html>"
File.open(outname, 'w') { |file|
	file.write(output)
}