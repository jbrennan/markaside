Markaside
=========

This is a super basic ruby script that takes a markdown document with some special syntax additions and parses it to an HTML page with a specified style. It's pretty damn basic and inflexible right now. It's a little error-prone too.

Usage
-----

Add this repo as a submodule of your project repo, then run

	ruby markaside/markaside.ruby

When you run this the first time in a new project, it'll generate a `markaside.json` file for you to fill out. Every time you run this afterwards, it'll use the info in the config file to generate output.

Configuration
-------------

`markaside` uses a configuration file named `markaside.json` to figure out your input and output files. All paths are relative to the current working directory from where you run the `markaside` script.

Options are:

    {
     "markdown_filename": "essay.md", // the name of the input markdown file
     "output_filename": "index.html", // the name of the output html file
     "html_title": "Programming Languages" // the <title> of the html document generated
    }


Requirements
------------

You need the `redcarpet` gem installed.

Special Syntax
--------------

The only extra syntax it has is for side notes. In a paragraph, write like this:

	This is my paragraph{Which includes side notes!} that really isn't very long but jeeze it ought to be long enough.

That should output sidenotes, with the appropriate \* characters on both ends. It'll bust if you put two notes in one paragraph, though.
