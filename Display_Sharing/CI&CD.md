# CI(Continuous Integration)

 - 지속적인 통합
 - AP에 대한 새로운 변경사항이 정기적으로 빌드 및 테스트 되어 공유 Repo에 통합되므로 다수의 개발자가 동시 코드 작업시 충돌 문제를 해결 가능

# CD(Continuous Delivery or Continuous Deployment)
 - 지속적인 서비스 제공 or 지속적인 배포
 - 지속적인 제공
    - AP에 적용된 변경 사항이 버그 테스트를 거쳐 Repo(예:GitHub)에 자동으로 업로드 되는 것
    - 운영 팀은 지속적으로 업로드되는 Repo를 실시간 프로덕션 환경으로 배포 가능 
    - 최소한의 노력으로 새로운 코드 배포를 목표로한다.
 - 지속적인 배포
    - AP에 적용된 변경 사항을 Repo에서 고객이 사용가능한 프로덕션 환경까지 자동으로 릴리스 하는 것을 의미

## CI/CD Tool 비교

 ### 1. Travis CI
 - 구동 환경 : Cloud
 - AWS 내 배포가능 서비스
   1. CodeDeploy
   1. Elastic Beanstalk
   1. Lambda
   1. OpsWorks
   1. S3
 - 가격
   - 무료 : Open Source Project만
   - 유료 : 69 USD/Month : 한번에 한개의 Job만 수행가능

 ### 1. CircleCI

# Docker
 - 컨테이너 기반의 오픈소스 가상화 플랫폼
 - 컨테이너와 함께 이미지
   - 이미지 : 컨테이너 실행에 필요한 파일과 설정값등을 포함하고 있는것, 변하지 않는 값(Immutable)[Window 설치 iso 같은?]
 - 도커 이미지는 [Docker hub](https://hub.docker.com/)에 등록하거나 Docker Registry 저장소를 직접만들어 관리 할 수 있다. 누구나 쉽게 이미지를 만들고 배포가 가능

# Kubernetes
 - Container Orchestration FrameWork
 - 컨테이너를 쉽고 빠르게 배포/확장하고 관리를 자동화해주는 오픈소스 플랫폼
 - 단순한 컨테이너 플랫폼이 아닌 **마이크로서비스**, 클라우드 플랫폼을 지향하고 컨테이너로 이루어진 것들을 손쉽게 담고 관리할 수 있는 그릇 역할을 합니다. 서버리스, CI/CD, 머신러닝 등 다양한 기능이 쿠버네티스 플랫폼 위에서 동작한다.



## 출처

 - CI/CD - https://www.redhat.com/ko/topics/devops/what-is-ci-cd
 - CI/CD 툴 비교 - https://medium.com/day34/ci-cd-tool-comparison-f710a4777852

 ## 참고
   ### CI/CD
  - MSA Automation(CI/CD) - https://waspro.tistory.com/447
  - MSA ,Kubernetes, CI/CD - https://medium.com/finda-tech/finda-msa%EB%A5%BC-%EC%9C%84%ED%95%9C-kubernetes-%EC%84%B8%ED%8C%85%EA%B3%BC-ci-cd-pipeline-%EA%B5%AC%EC%84%B1-%EA%B7%B8%EB%A6%AC%EA%B3%A0-monitoring-%EC%8B%9C%EC%8A%A4%ED%85%9C-%EA%B5%AC%EC%B6%95-1-783bf49af15b

  - Jenkins vs .GitLab - https://about.gitlab.com/devops-tools/jenkins-vs-gitlab.html
  
  - Gitlab-CI - https://lovemewithoutall.github.io/it/deploy-example-by-gitlab-ci/
  - Gitlab-CI Runner 소개 예제 - https://allroundplaying.tistory.com/21

  - 배민 CI/CD (Jenkins) - https://woowabros.github.io/experience/2018/06/26/bros-cicd.html

  ### Docker
  - 도커란 - https://subicura.com/2017/01/19/docker-guide-for-beginners-1.html

  ### Kubernetes

  - 쿠버네티스란 - https://kubernetes.io/ko/docs/concepts/overview/what-is-kubernetes/
  - What is Kubernetes? - https://www.popit.kr/kubernetes-introduction/