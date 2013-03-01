Tumblr Ticklr
=============
Post an item on Tumblr every day in an automated way.

Reads posts from named text file, one post per line

The Code
--------

TumblrTicklr uses the cute but somewhat frustrating dialect of JavaScript called
[Literate CoffeeScript](http://coffeescript.org/#literate). Literate Coffeescript
inverts the usual relationship between code and comments, and allows you to write
your code's documentation first (in Markdown) and then sprinkle code therein using
blocks of native CoffeeScript code.

*Warning* I wrote this as an experiment.

Our main tool is ntumblr:

	nt = require('ntumblr')

But we also have to read stuff from files:

	fs = require('fs')

And do cutesy stuff

	_ = require('underscore')

You must call it with your Tumblr-given auth token, auth secret, and blog name:

	TumblrTicklr = (postsTextFile, accessKey, accessSecret, blogName) ->
		lines = getLines postsTextFile
		next = findNextLine lines
		console.log next
		if next
			markAsUsed postsTextFile, lines, next
		next

	getLines = (textFile) ->
		_.reject fs.readFileSync(textFile, 'utf8').split('\n'),
			(line) -> !line

As for the text file: we need to determine what we've already posted, so we
mark those posts in the file with <-- current

	findNextLine = (lines) ->
		console.log lines
		for line, idx in lines
			console.log line, idx
			return lines[idx+1] if line.match(/<-- current$/)
		return lines[0]

	markAsUsed = (textFile, lines, lineUsed) ->
		currentSeen = 0
		fs.renameSync(textFile, textFile+'.bak')
		for line, idx in lines
			if line == lineUsed
				currentSeen = 1
				lines[idx] = lineUsed + '<-- current'
			else
				if !currentSeen
					lines[idx] = line.replace '<-- current', ''
		fs.writeFileSync textFile, (lines.join('\n'))

Expose the interface

	module.exports = TumblrTicklr
