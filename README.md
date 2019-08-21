# ES7-Tutorial

ElasticSearch 첫 번째 튜토리얼을 기술합니다.

본 스크립트는 외부 공인망을 기준으로 작성되었습니다.

## Product 별 버전 상세
```
Product Version. 7.3.0(2019/08/21 기준 Latest Ver.)
```
* [Elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.3.0-x86_64.rpm)
* [Kibana](https://artifacts.elastic.co/downloads/kibana/kibana-7.3.0-x86_64.rpm)

최신 버전은 [Elasticsearch 공식 홈페이지](https://www.elastic.co/downloads) 에서 다운로드 가능합니다.

## ES 7.x 버전에셔 변경된 사항
EX 6.x 버전에서 7.x 버전으로 넘어오면서 다양한 변화가 있었습니다. ([ES 7.x Breaking Changes](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes-7.0.html))

그 중 사용자가 직접 설정해야되는 부분과, default 로 설정되는 부분들에 대해 알아보겠습니다.

아래는 변경된 사항에 대해 다뤄볼 주제들입니다.

* [Network Changes](#Network-Changes)
  + ES 클러스터 노드 Network 설정 제약조건 추가

* [Discovery Changes](#Discovery-Changes)
  + ES 클러스터 노드 Discovery 및 Master 선출과정 변경 

* [Indices Changes](#Indices-Changes)
  + 인덱스 Primary Shard default 개수 5개에서 1개로 변경
  + 세그먼트 refresh 방식 변경

* [Mapping Changes](#Mapping-Changes)
  + \_all meta field 세팅 불가
  + 내부적으로 인덱스 내의 매핑 이름을 \_doc 하나로 고정하면서 매핑의 사용을 제거

* [Search & Query DSL Changes](#Search-&-Query-DSL-Changes)
  + Adaptive Replica Selection 이 default 로 설정됨
  + Scroll Query 에 request\_cache 사용 불가

* [Thread Pool Name Changes](#Thread-Pool-Name-Changes)
  + bulk 가 write 로 완전히 변경됨(configure 관련 이름까지)

* [Settings Changes](#Settings-Changes)
  + node.name 의 default 값이 랜덤한 값에서 호스트네임으로 변경됨

# Network Changes
#### 단일 호스트 network.host 설정 시 discovery 설정 필수
* 6.x 버전까지는 단일 호스트에서 discovery 설정 없이 network.host 를 정의할 수 있었습니다.
* 7.x 버전부터는 localhost 로 서비스를 하는 것이 아니면 network.host 를 정의한 순간 discovery 설정을 필수로 해주어야 합니다.

# Discovery Changes
#### ES 클러스터 노드 Discovery 및 Master 선출과정 변경
* ES 클러스터 노드 Discovery 및 Master 선출과정 변경 ([공식 레퍼런스 페이지 참고](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html))
* 기존의 마스터 후보 장비 목록을 설정하던 discovery.zen.ping.unicast.hosts 와 Split Brain 을 막기 위한 discovery.zen.minimum\_master\_nodes 설정이 없어지고 discovery.seed\_hosts 와 cluster.initial\_master\_nodes 설정이 위 설정들을 대체하게 됨
* discovery.seed\_hosts 
  + ES 클러스터링의 기준이 되는 마스터노드의 목록을 설정합니다. 
  + 해당 설정을 하지 않았을 경우에는 localhost 내에 9300 - 9305 포트를 스캔하여 해당 포트로 올라온 ES 프로세스끼리 클러스터링을 진행합니다. 
  + 기존 6.x 에서 discovery.zen.ping.unicast.hosts 를 설정하지 않으면 단일 노드로 클러스터링이 구성되는 반면, 7.x 에서 discovery.seed\_hosts 를 설정하지 않고 9300 - 9305 포트로 ES 가 2개 이상 올라와있지 않으면 ES 는 정상적으로 올라오지 않습니다. 
  + 단일 노드로 설정을 희망한다면 discovery.seed\_hosts 에 단일 노드의 주소를 설정해주어야 합니다.

* cluster.initial\_master\_nodes
  + ES 클러스터의 마스터를 선출하는 목록입니다.
  + 해당 설정에서 기재된 목록을 기준으로 discovery.zen.minimum\_master\_nodes 의 수를 자동으로 계산합니다.

* 프로덕션 환경에서는 둘 다 동일하게 설정하면 기존의 설정과 크게 다르지 않습니다.

# Indices Changes
#### 인덱스 Primary Shard default 개수 5개에서 1개로 변경
* 6.x 에서 number\_of\_shards 를 설정하지 않고 인덱스를 생성하면 기본적으로 5개의 Primary Shard 가 세팅되었던 부분이 기본으로 1개의 Primary Shard 로 생성되는 방식으로 변경

#### 세그먼트 refresh 방식 변경
* index.refresh\_interval 는 문서가 인덱싱 될 때 메모리 버퍼 캐시에 저장된 문서를 실제 물리 디스크로 내려 저장하는 주기를 의미하고 기본값은 1s 입니다.
* 이 값이 기본값인 1s 로 유지되는 경우, index.search.idle.after 에 설정된 시간만큼(기본값은 30s) 검색 요청이 없다면 검색 요청이 들어올 때 까지 refresh 를 하지 않습니다.

# Mapping Changes
####  \_all meta field 세팅 불가
* 문서의 전체 field 의 value 를 묶어서 비효율적으로 구성되는 \_all field 가 6.x 에서 deprecate 되었고 7.x 버전에서 완전히 제거되었습니다.

####  내부적으로 인덱스 내의 매핑 이름을 \_doc 하나로 고정하면서 매핑의 사용을 제거
* 하나의 인덱스에서 다중 타입을 구성할 수 있는 multi type 을 6.x 에서 deprecate 하고 가능하면 \_doc 라는 이름의 타입으로 쓸 것을 권고하다가 7.x 버전에서는 \_doc 라는 이름의 타입으로 이름을 고정하고, 인덱스 생성 시 타입 이름 기재 부분을 아예 제거하였습니다.
```bash
# 6.x
curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/es6test1 -d '{
  "mappings": {
    "_doc": {
      "properties": {
        "es6": {
          "type": "text"
        }
      }
    }
  }
}'
```
```bash
# 7.x
curl -s -H 'Content-Type: application/json' -XPUT http://localhost:9200/es7test1 -d '{
  "mappings": {
    "properties": {
      "es7": {
        "type": "text"
      }
    }
  }
}'
```

# Search & Query DSL Changes
#### Adaptive Replica Selection 이 default 로 설정됨
* ES 에 검색 요청이 들어오게 되면 기본적으로 replica shard 들을 대상으로 Round Robin 형태로 데이터를 요청합니다.

* 6.x 에서 좀 더 나은 상태에 있는 샤드로 부터 검색 결과를 받기 위해 Adaptive Replica Selection 기능이 추가되었고, 아래의 조건을 기준으로 동작합니다.
  + coordinating node 와 검색 요청에 응답한 replica shard 를 가진 data node 사이에 과거 요청들의 응답시간
  + data node 에서 검색 요청에 의해 응답하는 데 걸린 시간
  + data node 에서 사용한 search thread pool 의 queue size

* 7.x 에서는 이 기능이 default 로 설정되어 기존처럼 Round Robin 방식을 사용하기 위해서는 해당 기능을 false 로 설정해주어야 합니다.
```bash
PUT /_cluster/settings
{
    "transient": {
        "cluster.routing.use_adaptive_replica_selection": false
    }
}
```

#### Scroll Query 에 request\_cache 사용 불가
* 6.x 에서 deprecate 된 request\_cache: true 세팅이 완전히 제거되었습니다.

# Thread Pool Name Changes
#### bulk 가 write 로 완전히 변경됨(configure 관련 이름까지)
* 6.3 에서 write 로 이름이 변경된 bulk thread pool 이름이 관련 세팅까지 write 로 이름이 변경되었습니다.
* 튜토리얼에서는 thread\_pool.bulk.queue\_size 세팅이 thread\_pool.bulk.queue\_size 로 변경됩니다.

# Settings Changes
#### node.name 의 default 값이 랜덤한 값에서 호스트 네임으로 변경됨
* 기존에 random string 으로 구성되던 기본 ES 노드 네임이 7.x 버전부터 시스템의 호스트명으로 기본 ES 노드 네임을 설정합니다.


