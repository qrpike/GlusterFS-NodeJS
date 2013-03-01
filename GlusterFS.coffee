x2j				= require('xml2js').parseString
exec 			= require('child_process').exec
colors 			= require('colors')
Validator 		= require('validator').Validator


class GlusterFS

	constructor: (@params = {})->
		@volumeCommands = [
			'info','create','delete','start','stop','rename',
			'add-brick','remove-brick','rebalance','replace-brick',
			'set-transport','log filename','log locate','log rotate']
		@peerCommands = ['probe','detach','status']
		
	__run: (str, cb)=>
		console.log "Running Command: gluster #{str}".green
		exec "gluster #{str}", (err, stdout, stderr)->
			if err then return cb { error:true, reason:err }
			x2j stdout, (err,jsonData)->
				if err then return cb { error:true, reason:err }
				res = { error: false }
				res.data = jsonData.cliOutput
				cb res
	
	## Format a object into a string for the CLI ##
	formatOptions: (opts)=>
		str = for option,value of opts
			"#{option} #{value}"
		str.join ' '
		
	## All volume commands come through here ##
	volume: ( command, volname, cb, options = {})=>
		if not command?
			return cb { error:true, reason:'No command given' }
		if not command in @volumeCommands
			return cb { error:true, reason:'Command not found' }
		if not volname? and command isnt 'info'
			return cb { error:true, reason:'This command requires a volume name' }
			
			
		if command is 'info'
			volname = 'all' if not volname?
		
		@__run "volume #{command} #{volname} "+@formatOptions(options)+" --xml", cb
		
	
	peer: ( command, hostname, cb )=>
		if not command?
			return cb { error:true, reason:'Command not entered' }
		if not command in @peerCommands
			return cb { error:true, reason:'Command not found' }
		if not hostname? and command isnt 'status'
			return cb { error:true, reason:'This command requires a hostname' }
		
		cmd = "peer #{command}"
		cmd += " #{hostname}" if hostname?
		@__run cmd+" --xml", cb
		