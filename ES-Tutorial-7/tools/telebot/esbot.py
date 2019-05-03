#!/usr/bin/env python
# -*- coding: utf-8 -*-

import sys
import urllib3
import json

def es(cmd):
    try:
        header = { 'Content-Type': 'application/json' }
        data = {}
        if cmd[1] == "i":
            rtn = es_rtn('GET', "localhost:9200", data, header)
        else:
            rtn = "incorrect commands"
        print rtn
        return rtn

    except IndexError:
        rtn = "Usage : ./esbot [options] [Cluster URL]\n\n\
        i : ES Info\n\
        "
        print rtn
        return rtn

def es_rtn(method, cmd, data=None, header=None):
    http = urllib3.PoolManager()

    try:
        rtn = http.request(method,cmd,body=json.dumps(data),headers=header).data
    except urllib3.exceptions.HTTPError as errh:
        rtn = "Http Error:",errh

    return rtn

if __name__ == '__main__':
    es(sys.argv)
