# ES-Tutorial-6

ElasticSearch 여섯 번째 튜토리얼을 기술합니다.

본 스크립트는 외부 공인망을 기준으로 작성되었습니다.

## Product 별 버전 상세
```
Product Version. 6.6.0(2019/02/07 기준 Latest Ver.)
```
* [Elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.rpm)
* [Kibana](https://artifacts.elastic.co/downloads/kibana/kibana-6.6.0-x86_64.rpm)

최신 버전은 [Elasticsearch 공식 홈페이지](https://www.elastic.co/downloads) 에서 다운로드 가능합니다.

## InfluxDB & Grafana 설치하기

이 튜토리얼에서는 rpm 파일을 이용하여 실습합니다.

Elasticsearch 가 실행중인 아무 노드에서 실습합니다.

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo yum -y install git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ git clone https://github.com/benjamin-btn/ES-Tutorial-6.git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cd ES-Tutorial-6

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ ./tuto6
##################### Menu ##############
 $ ./tuto6 [Command]
#####################%%%%%%##############
         1 : install influxdb packages
         2 : start influxdb process
         3 : install grafana packages
         4 : start grafana process
#########################################

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ ./tuto6 1

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ ./tuto6 2

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ ./tuto6 3

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ ./tuto6 4

```

## Smoke Test

### InfluxDB

```bash 
[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-6]$ influx -precision rfc3339
Connected to http://localhost:8086 version 1.x.x
InfluxDB shell 1.x.x
> CREATE DATABASE mdb
> use mdb
> select * from docs

```

### Grafana

* Web Browser 에 [http://FQDN:3000](http://FQDN:3000) 실행

![Optional Text](image/grafana.png)

## Trouble Shooting

