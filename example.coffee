## Require the GlusterFS Module: ##
GlusterFS = require 'glusterfs'


## Create new GlusterFS Object ##
gfs = new GlusterFS


## Get the status of all Peers: ##
gfs.peer 'status', null, (res)->
	console.log 'Peer Status:', JSON.stringify(res)
	

## Get info for all volumes: ##
gfs.volume 'info', 'all', ( res )->
	console.log 'Volume Info (All Volumes)', JSON.stringify(res)