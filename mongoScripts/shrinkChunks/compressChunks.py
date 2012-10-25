#!/usr/bin/env python

import json
import sys

if len(sys.argv) != 2:
    print "Usage: %s <input file>" % sys.argv[0]
    exit

with open(sys.argv[1],'r') as input:
    chunks = json.load(input)
    pathChunks = dict()
    for chunk in chunks:
        if 'min' in chunk:
            path = chunk['min']['path']
            ts = chunk['min']['timestamp']
            #print "Checking %s in %s" % (path, pathChunks.keys())
            if path in pathChunks:
                # See if we can merge
                pathList = pathChunks[path]
                #print "List for %s is %s" % (path, pathList)
                if pathList[-1]['max']['timestamp'] == ts:
                    #print "Merging %s, new max = %s" % (chunk, chunk['max']['timestamp'])
                    print "db.chunks.remove({'_id':'%s'});" % chunk['_id']
                    pathList[-1]['max']['timestamp'] = chunk['max']['timestamp']
                    print "db.chunks.update({'_id':'%s'},{$set:{'max.timestamp':%s}},false,false);" % (pathList[-1]['_id'], pathList[-1]['max']['timestamp'])
                else:
                    #print "New chunk span starting at %s" % chunk
                    pathChunks[path] = pathList + chunk
            else:
                #print "New path list for %s with max %s" % (path, chunk['max']['timestamp'])
                pathChunks[path] = [] + [chunk]
    
#    for pl in pathChunks.values():
#        for newChunk in pl:
#            print "db.chunks.update({'_id':'%s'},{$set:{'max.timestamp':%s}},false,false);" % (newChunk['_id'], newChunk['max']['timestamp'])
                    

