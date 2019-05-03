# System Script 3rd

ElasticSearch 세 번째 System 명령어 스크립트를 기술합니다.

## Elasticsearch 환경설정 - 그 외 시스템 설정 

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo vi /etc/security/limits.conf

elasticsearch               soft    nofile          65536
elasticsearch               hard    nofile          65536

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo vi /etc/security/limits.d/20-nproc.conf

elasticsearch               soft    noproc          4096
elasticsearch               hard    noproc          4096

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo vi /etc/sysconfig/elasticsearch

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo vi /etc/sysctl.conf

vm.max_map_count=262144

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo sysctl -p

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo swapoff -a

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo vi /etc/sysctl.conf

vm.swappiness = 1

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo sysctl -p
```

## Bulk API 

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ curl -H 'Content-Type: application/x-ndjson' -XPOST 'localhost:9200/bank/account/_bulk?pretty' --data-binary @accounts.json

```
