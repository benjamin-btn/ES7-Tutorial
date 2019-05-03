# ES-Tutorial-7

ElasticSearch 일곱 번째 튜토리얼을 기술합니다.

본 스크립트는 외부 공인망을 기준으로 작성되었습니다.

## Product 별 버전 상세
```
Product Version. 6.6.0(2019/02/07 기준 Latest Ver.)
```
* [Elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.rpm)
* [Kibana](https://artifacts.elastic.co/downloads/kibana/kibana-6.6.0-x86_64.rpm)

최신 버전은 [Elasticsearch 공식 홈페이지](https://www.elastic.co/downloads) 에서 다운로드 가능합니다.

## Tutorial 7 설치

이 튜토리얼에서는 rpm 파일을 이용하여 실습합니다.

ES-Tutorial-6 을 진행했던 장비에서 실습합니다.

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo yum -y install git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ git clone https://github.com/benjamin-btn/ES-Tutorial-7.git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cd ES-Tutorial-7

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-7]$ ./tuto7
##################### Menu ##############
 $ ./tuto7 [Command]
#####################%%%%%%##############
         1 : install curator package
         2 : configure es hot template
         3 : install elasticdump package
         4 : install telegram package
         5 : install ansible package
#########################################

```

