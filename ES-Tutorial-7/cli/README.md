# System Script 7th

## Ansible 배포환경 준비하기
* ansible 은 ssh 기반으로 배포대상에 접근/배포 진행
  + 배포서버의 ssh 공개키가 배포 대상버서의 known_hosts 에 등록되어 있어야 함

* 배포서버에서 ssh 공개키 생성

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ ssh-keygen
Generating public/private rsa key pair.
Enter file in which to save the key (/home/ec2-user/.ssh/id_rsa):
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /home/ec2-user/.ssh/id_rsa.
Your public key has been saved in /home/ec2-user/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:MZdDy8G/zSRSkI2jLehAoIoaW2yFEHYaftZXigdKnxY ec2-user@ip-xxx-xxx-xxx-xxx.ap-southeast-1.compute.internal
The key's randomart image is:
+---[RSA 2048]----+
|o+.+ E   o+=     |
|oo=.= = oo=+o    |
|.o.=.* =oo*+     |
|o.o.o + o+o.o .  |
|+ +  o  S. . *   |
|.=    .     . o  |
|o                |
|                 |
|                 |
+----[SHA256]-----+

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ ls ~/.ssh
authorized_keys  id_rsa  id_rsa.pub  known_hosts

[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ cat ~/.ssh/id_rsa.pub
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClJdQ0NStPDIyJo+VHMSDAyvvZ/ASOXQLoz3z7HU+ZN0bBS6bQiY0Ve4rbzGJ6ZXBRshrKh8DiwzAIVcKfLm0ijdTX43ZL/jhz2f8zuLKO6hh5pW9pEoD+TMOX3mwLmEFqTcmgWnv/e0gLJWVNk8mLUJqDfC23c1NUnWYyGvmcK2H8ypS330lk5KugvQkSX6FpbbrWt3M61N2xH55amHnl1nuO8mwlcqLMdsI+RfFm+9RNPC/vFv3fGFTz2i1sAkr3UCe19sxLMbh1l4SPjlqflTmc5/PJs9iDWAI8Fe7DXOxB5krAkAdKM52oh49DazLB3l+WAB6sRAQM+276L ec2-user@ip-xxx-xxx-xxx-xxx.ap-southeast-1.compute.internal

```

* 배포 대상서버에 배포서버 공개키를 등록하여 배포서버가 인증없이 배포 대상서버에 접근할 수 있도록 설정

```bash
[ec2-user@ip-xxx-xxx-xxx-xxx ~]$ echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQClJdQ0NStPDIyJo+VHMSDAyvvZ/ASOXQLoz3z7HU+ZN0bBS6bQiY0Ve4rbzGJ6ZXBRshrKh8DiwzAIVcKfLm0ijdTX43ZL/jhz2f8zuLKO6hh5pW9pEoD+TMOX3mwLmEFqTcmgWnv/e0gLJWVNk8mLUJqDfC23c1NUnWYyGvmcK2H8ypS330lk5KugvQkSX6FpbbrWt3M61N2xH55amHnl1nuO8mwlcqLMdsI+RfFm+9RNPC/vFv3fGFTz2i1sAkr3UCe19sxLMbh1l4SPjlqflTmc5/PJs9iDWAI8Fe7DXOxB5krAkAdKM52oh49DazLB3l+WAB6sRAQM+276L ec2-user@ip-xxx-xxx-xxx-xxx.ap-southeast-1.compute.internal' >> ~/.ssh/known_hosts

```

* 완료되었으면 배포서버에서 배포 대상서버로 ssh 접근 테스트

* 정상접근 확인 후 ansible 을 이용해 배포 시작



