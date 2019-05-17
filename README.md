# ES7-Tutorial

ElasticSearch 첫 번째 튜토리얼을 기술합니다.

본 스크립트는 외부 공인망을 기준으로 작성되었습니다.

## Product 별 버전 상세
```
Product Version. 7.0.1(2019/05/03 기준 Latest Ver.)
```
* [Elasticsearch](https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.0.1-x86_64.rpm)
* [Kibana](https://artifacts.elastic.co/downloads/kibana/kibana-7.0.1-x86_64.rpm)

최신 버전은 [Elasticsearch 공식 홈페이지](https://www.elastic.co/downloads) 에서 다운로드 가능합니다.

## ES 7.x 버전에셔 변경된 사항
EX 6.x 버전에서 7.x 버전으로 넘어오면서 다양한 변화가 있었습니다. ([ES 7.x Breaking Changes](https://www.elastic.co/guide/en/elasticsearch/reference/current/breaking-changes-7.0.html))

그 중 사용자가 직접 설정해야되는 부분과, default 로 설정되는 부분들에 대해 알아보겠습니다.

아래는 변경된 사항에 대해 다뤄볼 주제들입니다.

* [Discovery Changes](#Discovery-Changes)
  + ES 클러스터 노드 Discovery 및 Master 선출과정 변경 ([공식 레퍼런스 페이지 참고](https://www.elastic.co/guide/en/elasticsearch/reference/current/discovery-settings.html))

* Indices Changes
  + 인덱스 Primary Shard default 개수 5개에서 1개로 변경
  + 세그먼트 refresh 방식 변경

* Mapping Changes
  + \_all meta field 세팅 불가
  + 내부적으로 인덱스 내의 매핑 이름을 \_doc 하나로 고정하면서 매핑의 사용을 제거

* Search & Query DSL Changes
  + Adaptive Replica Selection 이 default 로 설정됨
  + Scroll Query 에 request\_cache 사용 불가

* Thread Pool Name Changes
  + bulk 가 write 로 완전히 변경됨(configure 관련 이름까지)

* Settings Changes
  + node.name 의 default 값이 랜덤한 값에서 호스트네임으로 변경됨

# Discovery Changes
#### ES 클러스터 노드 Discovery 및 Master 선출과정 변경

