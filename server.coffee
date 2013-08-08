express = require 'express'
exec = require('child_process').exec
temp = require('temp')
fs = require('fs')

app = express()
app.use express.static 'public'
app.use express.bodyParser()
app.use app.router

app.post '/execute', (req,res)=>
	temp.open 'xquery', (err,info) =>
		fs.write info.fd, req.body.query
		fs.close info.fd, (err) =>
			exec 'basexclient -Uxquery -Pxquery '+info.path, [], (status,stdout,stderr)=>
				res.send
					status: status
					error: stderr.replace(/.*?\n/,'').trim()
					output: stdout.trim()

app.listen 8080
