# esbot

ElasticSearch 클러스터 상태 체크를 하는 스크립트를 기술합니다.
* 개발환경 - Python 2.7.10
* sys, json, urllib3 site package import

## esbot 스크립트 설치하기

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ sudo yum -y install git
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cd /usr/local/
[ec2-user@ip-xxx-xxx-xxx-xxx local]$ sudo git clone https://github.com/benjamin-btn/esbot.git
[ec2-user@ip-xxx-xxx-xxx-xxx local]$ cd esbot
[ec2-user@ip-xxx-xxx-xxx-xxx esbot]$ ./esbot
Usage : ./esbot [options] [Cluster URL]

        i : ES Info
```
## 확장 방법

```bash
def es(cmd):
    try:
        header = { 'Content-Type': 'application/json' }
        data = {}
        if cmd[1] == "i":
            es_rtn('GET', cmd[2], data, header)
        else:
            print "incorrect commands"
    except IndexError:
        print "Usage : ./esbot [options] [Cluster URL]\n\n\
        i : ES Info\n\
        "
```

기능을 추가할 때마다 Usage 에 옵션 및 설명 추가

구현부에 elif 로 분기하여 body 를 data = {} 에 정의하고 

HTTP Method 와 cmd[2] 를 cmd[2] + "_cat/health" 형태로 변경
