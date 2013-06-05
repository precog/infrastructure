#!/usr/bin/env python

from precog import Precog, PrecogServiceError
import json
import sys
from sys import argv
import re

if len(argv) != 5:
    print "Usage: %s host accountId apiKey filename" % argv[0]
    sys.exit(1)

host = argv[1]
accountId = argv[2]
apiKey = argv[3]
filename = argv[4]

lineFormat = re.compile("^Type: (?P<type>\d+), offset: \d+, payload: (?P<payload>{.*})")

client = Precog(apiKey, accountId, basepath = accountId, host = host)

count = 1

for line in open(filename, 'r'):
    m = lineFormat.match(line)

    if m:
        eventMessage = int(m.group("type"))
        payload = json.loads(m.group("payload"))
        path = payload["path"]
        pathlist = path.split('/')
        del pathlist[2]
        del pathlist[1]
        del pathlist[0]
        newpath = '/'.join(pathlist)

        if eventMessage == 1:
            data = [value["jvalue"] for value in payload["data"]]
            print "Ingesting %s at %s" % (payload["path"], newpath)
            try:
                client.append_all(newpath, data)
            except PrecogServiceError as e:
                print "Precog Service Error:\n%s" % e
                raise Exception("Failure reingesting line %d: %s" % (count, line))

        elif eventMessage == 3:
            print "Deleting %s at %s" % (payload["path"], newpath)
            try:
                client.delete(newpath)
            except PrecogServiceError as e:
                print "Precog Service Error:\n%s" % e
                raise Exception("Failure archiving line %d: %s" % (count, line))

        else:
            raise Exception("Unknown event type %d on line %d: %s" % (eventMessage, count, line))

        count += 1

    else:
        raise Exception("Unable to match line %d: %s!" % (count, line))

