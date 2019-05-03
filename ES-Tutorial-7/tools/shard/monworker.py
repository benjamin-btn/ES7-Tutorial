#!/usr/bin/env python
# -*- coding: utf-8 -*-

import urllib3
import json
from datetime import datetime
from influxdb import InfluxDBClient

influxUrl = "localhost"
esUrl = "localhost:9200"

def get_ifdb(db, host=influxUrl, port=8086, user='root', passwd='root'):
	client = InfluxDBClient(host, port, user, passwd, db)
	try:
		client.create_database(db)
	except:
		pass
	return client

def my_test(ifdb):
        local_dt = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')

        statVal = es_mon()
	point = [{
		"measurement": 'docs',
                "tags": {
                        "type": "ec2",
                },
		"time": local_dt,
		"fields": {
                    "pri_doc": statVal[0],
                    "tot_doc": statVal[1],

                    "pri_idx_tot": statVal[2],
                    "pri_idx_mil": statVal[3],
                    "tot_idx_tot": statVal[4],
                    "tot_idx_mil": statVal[5],

                    "pri_squery_tot": statVal[6],
                    "pri_squery_mil": statVal[7],
                    "tot_squery_tot": statVal[8],
                    "tot_squery_mil": statVal[9],

                    "pri_sfetch_tot": statVal[10],
                    "pri_sfetch_mil": statVal[11],
                    "tot_sfetch_tot": statVal[12],
                    "tot_sfetch_mil": statVal[13],

                    "pri_sscroll_tot": statVal[14],
                    "pri_sscroll_mil": statVal[15],
                    "tot_sscroll_tot": statVal[16],
                    "tot_sscroll_mil": statVal[17],

                    "pri_ssuggest_tot": statVal[18],
                    "pri_ssuggest_mil": statVal[19],
                    "tot_ssuggest_tot": statVal[20],
                    "tot_ssuggest_mil": statVal[21]
		}
	}]

	ifdb.write_points(point)

def es_mon():
    http = urllib3.PoolManager()
    header = { 'Content-Type': 'application/json' }
    monCmd = esUrl + "/_stats"

    try:
        rtn = http.request("GET",monCmd,body=json.dumps(None),headers=header)
    except urllib3.exceptions.HTTPError as errh:
        print ("Http Error:",errh)

    monData = json.loads(rtn.data)
    rtnVal = []
    rtnVal.append(monData['_all']['primaries']['docs']['count'])
    rtnVal.append(monData['_all']['total']['docs']['count'])

    rtnVal.append(monData['_all']['primaries']['indexing']['index_total'])
    rtnVal.append(monData['_all']['primaries']['indexing']['index_time_in_millis'])
    rtnVal.append(monData['_all']['total']['indexing']['index_total'])
    rtnVal.append(monData['_all']['total']['indexing']['index_time_in_millis'])

    rtnVal.append(monData['_all']['primaries']['search']['query_total'])
    rtnVal.append(monData['_all']['primaries']['search']['query_time_in_millis'])
    rtnVal.append(monData['_all']['total']['search']['query_total'])
    rtnVal.append(monData['_all']['total']['search']['query_time_in_millis'])

    rtnVal.append(monData['_all']['primaries']['search']['fetch_total'])
    rtnVal.append(monData['_all']['primaries']['search']['fetch_time_in_millis'])
    rtnVal.append(monData['_all']['total']['search']['fetch_total'])
    rtnVal.append(monData['_all']['total']['search']['fetch_time_in_millis'])

    rtnVal.append(monData['_all']['primaries']['search']['scroll_total'])
    rtnVal.append(monData['_all']['primaries']['search']['scroll_time_in_millis'])
    rtnVal.append(monData['_all']['total']['search']['scroll_total'])
    rtnVal.append(monData['_all']['total']['search']['scroll_time_in_millis'])

    rtnVal.append(monData['_all']['primaries']['search']['suggest_total'])
    rtnVal.append(monData['_all']['primaries']['search']['suggest_time_in_millis'])
    rtnVal.append(monData['_all']['total']['search']['suggest_total'])
    rtnVal.append(monData['_all']['total']['search']['suggest_time_in_millis'])

    return rtnVal

if __name__ == '__main__':
    ifdb = get_ifdb(db='mdb')
    my_test(ifdb)

# while(true); do ./monworker.py; done
