#!/usr/bin/env python
#-*- coding: utf-8 -*-

import urllib3
import json
import threading
import time
import argparse
import logging
import sys

from urllib3 import HTTPConnectionPool

parser = argparse.ArgumentParser()

parser.add_argument("--url", help="the url of cluster", required=True)
parser.add_argument("--port", help="the port of cluster (default 9200)", default=9200, required=False)
parser.add_argument("--threads", help="the number of search threads (default 1)", default=1, required=False)
parser.add_argument("--requests", help="the number of times search request of cluster (default 1)", default=1, required=False)
parser.add_argument("--index_name", help="the name of index to test", required=True)
parser.add_argument("--output_file", help="output file name (default STDOUT)", required=False, type=str)
parser.add_argument("--verbose", help="verbose mode (default False)", default=False, action="store_true", required=False)

args = parser.parse_args()

url = args.url
port = args.port
threads = int(args.threads)
requests = int(args.requests)
index_name = args.index_name
output_file = args.output_file
verbose = args.verbose

logger = logging.getLogger("crumbs")
logger.setLevel(logging.DEBUG)


if output_file != None :
    logger.addHandler(logging.FileHandler(output_file))
else:
    logger.addHandler(logging.StreamHandler(sys.stdout))

MAX_THREAD=threads
MAX_REQUESTS=requests

query = {
  "from":0, "size":10000,
  "query": {
    "query_string": {
      "query": "*"
    }
  }
}

#query = {
#    "from":0, "size":10000,
#    "query": {
#        "query_string": {
#            "query": "*"
#        }
#    }
#}

encoded_data = json.dumps(query).encode('utf-8')

es_connection_pool = HTTPConnectionPool(url, port=port, maxsize=100)

took_data = {}

def query_to_es(index):

    for i in range(0,MAX_REQUESTS) :

        response = es_connection_pool.request(
                    'GET',
                    '/%s/_search' % index,
                    body=encoded_data,
                    headers={'Content-Type': 'application/json'}
        )

        search_response_data = json.loads(response.data)

        if verbose :

            response = es_connection_pool.request(
                    'GET',
                    '/_cat/indices/%s?h=dc,ss,sc&format=json' % (index_name)
            )

            index_data = json.loads(response.data)[0]

            logger.info( "%s\t%s\t%s\t%s" % ( index_data['dc'], index_data['ss'], index_data['sc'], search_response_data['took'] ) )

        took_data[index].append(search_response_data['took'])

        time.sleep(1)



threads = []

took_data[index_name] = []

for i in range(0,MAX_THREAD) :
    thread = threading.Thread(target=query_to_es, args=[index_name])
    thread.start()

    threads.append(thread)

for thread in threads:
    thread.join()

for took in took_data :

    total_took = 0

    for elapsed_time in took_data[took]:

        total_took = total_took + elapsed_time

    logger.info("== RESULT ==")
    logger.info("[INDEX :%s] average took time : %d ms" % ( took, total_took/len(took_data[took])))
    logger.info("[INDEX :%s] max took time : %d ms" % ( took, max(took_data[took] ) ) )
    logger.info("[INDEX :%s] min took time : %d ms\n\n" % ( took, min(took_data[took] ) ) )

# while(true); do ./search_test.py --url ec2-3-16-8-131.us-east-2.compute.amazonaws.com --threads 1 --requests 1 --index_name bank; done
