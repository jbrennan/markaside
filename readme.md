Markaside
=========

This is a super basic ruby script that takes a markdown document with some special syntax additions and parses it to an HTML page with a specified style. It's pretty damn basic and inflexible right now. It's a little error-prone too.

Usage
-----

	ruby markaside.ruby your_md_file.md "Your Great HTML Title"

Requirements
------------

You need the `redcarpet` gem installed.

Special Syntax
--------------

The only extra syntax it has is for side notes. In a paragraph, write like this:

	This is my paragraph{Which includes side notes!} that really isn't very long but jeeze it ought to be long enough.

That should output sidenotes, with the appropriate \* characters on both ends. It'll bust if you put two notes in one paragraph, though.