# ES-Tutorial-5

ElasticSearch 다섯 번째 튜토리얼을 기술합니다.

본 스크립트는 외부 공인망을 기준으로 작성되었습니다.

## Product 별 버전 상세
```
Product Version. 6.6.0(2019/02/07 기준 Latest Ver.)
```
* [Elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-6.6.0.rpm)
* [Kibana](https://artifacts.elastic.co/downloads/kibana/kibana-6.6.0-x86_64.rpm)

최신 버전은 [Elasticsearch 공식 홈페이지](https://www.elastic.co/downloads) 에서 다운로드 가능합니다.

## Nori Plugin 다뤄보기

이 튜토리얼에서는 rpm 로 설치된 ES 기준으로 실습합니다.

Elasticsearch 가 실행중인 아무 노드에서 실습합니다.

[Nori Analyzer 공식 레퍼런스 페이지](https://www.elastic.co/guide/en/elasticsearch/plugins/current/analysis-nori.html) 를 참고해주세요.

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo yum -y install git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ git clone https://github.com/benjamin-btn/ES-Tutorial-5.git

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cd ES-Tutorial-5

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5
##################### Menu ##############
 $ ./tuto5 [Command]
#####################%%%%%%##############
         1 : install nori plugin
         2 : restart es process
         3 : make a nori mappings
         4 : standard analyzer tokens
         5 : nori analyzer tokens
         6 : nori analyzer indexing
         7 : nori analyzer searching
#########################################

```

1) /usr/share/elasticsearch/bin/elasticsearch-plugin install analysis-nori 로 Nori 설치
2) Nori 플러그인 설치 사항을 반영하기 위해 롤링리스타트로 전체 노드 재시작 진행
3) 재시작과 동시에 Nori 의 사전파일 userdict_ko.txt 를 /etc/elasticsearch 밑에 생성

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 1

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 2

```

4) Nori Analyzer 를 쓰기 위한 테스트 인덱스 생성

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 3

curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/noritest1 -d '
{
  "settings": {
    "index": {
      "analysis": {
        "tokenizer": {
          "nori_user_dict": {
            "type": "nori_tokenizer",
            "decompound_mode": "mixed",
            "user_dictionary": "userdict_ko.txt"
          }
        },
        "analyzer": {
          "my_analyzer": {
            "type": "custom",
            "tokenizer": "nori_user_dict"
          }
        }
      }
    }
  },
  "mappings": {
    "_doc": {
      "properties": {
        "norimsg": {
          "type": "text",
          "analyzer": "my_analyzer"
        }
      }
    }
  }
}'

```

## Smoke Test

```bash
[ec2-user@ip-172-31-4-45 ES-Tutorial-5]$ ./tuto5 4
## Standard Analyzer Tokens
## text : Winter is Coming!!!
{
  "tokens" : [
    {
      "token" : "winter",
      "start_offset" : 0,
      "end_offset" : 6,
      "type" : "<ALPHANUM>",
      "position" : 0
    },
    {
      "token" : "is",
      "start_offset" : 7,
      "end_offset" : 9,
      "type" : "<ALPHANUM>",
      "position" : 1
    },
    {
      "token" : "coming",
      "start_offset" : 10,
      "end_offset" : 16,
      "type" : "<ALPHANUM>",
      "position" : 2
    }
  ]
}

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 5
## Nori Analyzer Tokens
## text : 21세기 세종계획
{
  "tokens" : [
    {
      "token" : "21",
      "start_offset" : 0,
      "end_offset" : 2,
      "type" : "word",
      "position" : 0
    },
    {
      "token" : "세기",
      "start_offset" : 2,
      "end_offset" : 4,
      "type" : "word",
      "position" : 1
    },
    {
      "token" : "세종",
      "start_offset" : 5,
      "end_offset" : 7,
      "type" : "word",
      "position" : 2
    },
    {
      "token" : "계획",
      "start_offset" : 7,
      "end_offset" : 9,
      "type" : "word",
      "position" : 3
    }
  ]
}

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 6
## Nori Analyzer Indexing
## norimsg : 21세기 세종계획
{"_index":"noritest1","_type":"_doc","_id":"sz1iRGkB78Gpz5ewOq03","_version":1,"result":"created","_shards":{"total":2,"successful":2,"failed":0},"_seq_no":1,"_primary_term":1}[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$

[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ ./tuto5 7
## Nori Analyzer Searching
## norimsg : 세종
{
  "took" : 28,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "skipped" : 0,
    "failed" : 0
  },
  "hits" : {
    "total" : 2,
    "max_score" : 0.2876821,
    "hits" : [
      {
        "_index" : "noritest1",
        "_type" : "_doc",
        "_id" : "sz1iRGkB78Gpz5ewOq03",
        "_score" : 0.2876821,
        "_source" : {
          "norimsg" : "21세기 세종계획"
        }
      }
    ]
  }
}

```

![Optional Text](image/noridict1.jpg)

대학 + 생선 + 교회

대학생 + 선교회

![Optional Text](image/noridict2.jpeg)

동시흥 + 분기점

동시 + 흥분 + 기점


## Trouble Shooting

### Elasticsearch
Smoke Test 가 진행되지 않을 때에는 elasticsearch.yml 파일에 기본으로 설정되어있는 로그 디렉토리의 로그를 살펴봅니다.

path.logs: /var/log/elasticsearch 로 설정되어 cluster.name 이 적용된 파일로 만들어 로깅됩니다.

위의 경우에는 /var/log/elasticsearch/mytuto-es.log 에서 확인할 수 있습니다.

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ES-Tutorial-5]$ sudo vi /var/log/elasticsearch/mytuto-es.log
```

