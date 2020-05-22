# 1. WebRTC란

 - plugin-free web - Real Time Communication
    - 별도의 플러그인 설치없이 실시간 소통이 가능하도록 만들어주는 기술.
- 테스트 페이지 제공 ([appr.tc](https://appr.tc/))
- 기본적으로는 P2P(Peer to Peer), 즉 두 단말의 1:1 통신을 기본으로 한다.
>   - 대규모 방송 서비스를 구축하건, 컨텐츠 가공이 필요할 경우 **중앙 서버 구축이 필요**
>       - 목적에 따라 두가지 아키텍처를 고려한다
>           1. SFU
>           1. MCU
>   - SFU(Selective Forwarding Unit)
>       - 믹싱하지않고 트래픽을 선별적으로 배분해서 보내주는 방식. 각 peer 연결 할당과 encrypt/decrypt 역할을 서버가 담당한다. **1:N 스트리밍 구조에 적합**
>   - MCU(Multipoint Control Unit)
>       - 한쪽 peer에 서버를 두고, 들어오는 트래픽을 서버에서 믹싱해서 다시 내보내는 방식
>       - 클라이언트와 네트워크의 부담이 줄어드는 반면, 중앙서버의 컴퓨팅 파워가 다수 요구
>       - 낡은 기술 + 서버 운용비용이 높아 WebRTC와 같은 실시간성 보장이 우선인 서비스인 경우 장점이 상쇄된다고 언급이 된다.

* 진행될 프로젝트에서는 SFU 사용

## 1.1 구조

 - 실시간 소통을 위해 필요 사항 과정
 1. 기기의 스트리밍 오디오/ 비디오/ 데이터를 가져올 수 있을 것
 1. 소통하고자 하는 기기의 IP 주소와 포트 등 네트워크 데이터가 필요
 1. 에러의 보고, 세션의 초기화를 위한 신호 통신 관리
 1. 서로 소통할 수 있는 해상도인지, 코덱은 맞는지 등의 capability 정보 교환
 1. 실제 연결
 1. 연결 이후 스트리밍 오디오 / 비디오 / 데이터를 주고 받을 수 있어야 한다.

 - 위의 과정을 위해 WebRTC가 제공하는 API
    - MediaStream : 사용자의 카메로 혹은 마이크 등 input 기기의 데이터 스트림에 접근
    - RTCPeerConnection : 암호화/ 대역폭 관리 기능. 오디오 / 비디오 연결 담당
        - 패킷 로스 숨김
        - 에코 캔슬링(echo cancellation, 에코를 제거해 통화음질 향상)
        - 대역폭 조절
        - dynamic jitter buffering
        - automatic gain control(음량조절 등)
        - 노이즈 제거와 압축
        - 이미지 클리닝
    - RTCDataChannel : 일반적인 데이터 P2P 통신
> - 위의 3가지 API는 일부만 만족한다. 나머지 자잘한 일들은 **Signaling**이라는 과정을 통해 관리한다. 즉, 크게보면 WebRTC를 사용한 통신은 두개로 나뉜다.
>   1. Signaling을 통해 통신할 peer 간 정보를 교환.(네트워크 정보, capability 정보, 세션 수립 등)
>   1. WebRTC를 사용해 연결을 맺고, peer의 기기에서 미디어를 가져와 교환.

# 2. Signaling

 - Signaling은 통신을 조율할 메시지를 주고 받는 일련의 과정을 의미(메타 데이터의 교환)
 - 위에 테스트 페이지인 [appr.tc](https://appr.tc/)는 XHR과 Channel API를 사용해 Signaling을 구현했고, 구글 코드랩에서는 Node 서버위에 soket.io를 사용해서 만들었다.

 ## 2.1 Signaling 역할

 - Session Control Messages : 통신의 초기화, 종료, 에러 리포트
 - Network Configuration : 외부에서 보는 내 컴퓨터의 IP 주소와 포트 확인
 - Media Capabilites : 내 브라우저와 상대브라우저가 사용 가능한 코덱, 해상도 확인

 > - 위의 작업은 스트리밍이 시작되기 전에 완료되어야 한다.

### 2.1.1 Signaling 작업 내역

1. 네트워크 정보 교환 Network configuration
    - ICE 프레임워크를 사용해 서로의 IP와 포트를 찾는과정
    - candidate에 서로를 추가
1. 미디어 정보 교환 Media Capabilities
    - offer 와 answer 로직으로 진행
    - 형식은 SDP(Session Description Protocol)
1. Session Control Messages 위 과정에서 필요한 마이너한 과정들을 채워준다.

- Signaling 을 성공적으로 마치면, 실제 데이터(미디어, 영상, 음성 등)는 Peer To Peer로 통신하게 된다.

> - ICE(Interactive Connectivity Establishment) 프레임워크는 기기를 발견하고 연결하기 위한 프레임 워크
>   1. ICE는 UDP를 통해 기기들을 서로 직접 연결시도한다.
>       - 연결 성공 -> 미디어 교환
>       - 연결 실패 -> NAT혹은 방화벽에 막힌상태
>   1. 기기가 NAT뒤에 있을 경우 STUN서버가 이를 해결 가능
>       - STUN(Session Traversal Utilities for NAT)는 기기의 공인 IP를 알려준다. 기기의 NAT가 직접 연골을 허용하는지, 아닌지 파악하는 역할도 한다.
>           1. 클라이언트는 STUN 서버에 요청을 보낸다. STUN 서버는 클라이언트의 공인 주소와, 클라이언트가 NAT 뒤에서 접근이 되는지 알려준다.
>           1.직접 다른기기와 통신
>               - 연결 성공 -> 미디어 교환
>               - 연결 실패 -> TURN 서버로 넘긴다.
>       - TURN(Traversal Using Relays around NAT)는 Symmetric NAT의 제약조건을 위회하기 위해 만들어졌다. TURN서버와 연결을 맺고, 이 서버가 모든 교환과정을 중개해준다. 모든 기기는 TURN 서버로 패킷를 보내고, 서버가 이를 포워딩 한다. 당연히 오버헤드가 있고 **다른 대안이 없을 경우에만 사용한다.**
>   1. 어떤 라우터는 Symmetric NAT를 적용하는 경우가 있다.
>       - Symmetric NAT : 목적지에 따라서 같은 private IP의 노드를 다른 공인 IP와 포트로 매핑해준다. 이 경우 라우터는 이전에 연결했던 기기에서의 연결만 허용한다.

## 2.2 서버의 역할

 - 단순 P2P에 서버가 필요한 경우가 존재한다.
 - 서버의 역할
    - 사용자 탐색과 통신 / Signaling
    - NAT / 방화벽 탐색
    - Peer to Peer 통신 서버 시 중계 서버

> - NAT(Network Address Translation)은 기기에 공인 IP를 부여하는 기술이다. 라우터에 설정하는데, 라우터는 공인 IP를 갖고, 라우터에 연결된 모든 기기는 사설 IP를 갖는다. 기기가 요청할 것이 생기면, 라우터의 고유한 포트를 사용해서 사설 IP에서 공인 IP로 변환한다(translation). 어떤 라우터는 접근할 수 있는 노드를 제한 할 수 있다.

-------
# 출처
- https://juneyr.dev/webrtc-basics
- https://www.html5rocks.com/ko/tutorials/webrtc/basics/
- http://html5rocksko.blogspot.com/2014/03/getting-started-with-webrtc.html
- https://brunch.co.kr/@linecard/154

# 참고
 - WebRTC 화상 구현 예 - https://dksshddl.tistory.com/entry/webRTC-%EC%9B%B9RTC-%EC%98%88%EC%A0%9C%EB%A1%9C-%ED%99%94%EC%83%81-%EC%B1%84%ED%8C%85-%EA%B5%AC%ED%98%84%ED%95%98%EA%B8%B0
 - WebRTC 튜토리얼 - https://codelabs.developers.google.com/codelabs/webrtc-web/#0
- RTP(Real-time Transport Protocol) 분석 - https://brunch.co.kr/@linecard/154
- WebRTC 개념 및 사용법 - https://developer.mozilla.org/ko/docs/Web/API/WebRTC_API
- STUN, TUN 참고 - https://alnova2.tistory.com/1110
- ICE, STUN, TUN 정리 - https://brunch.co.kr/@linecard/156
- WebRTC 간단 요약 - https://wecomm.tistory.com/3
- **WebRTC 예제 및 요약본** - https://velog.io/@ehdrms2034/WebRTC-%EC%9B%B9%EB%B8%8C%EB%9D%BC%EC%9A%B0%EC%A0%80%EB%A1%9C-%ED%99%94%EC%83%81-%EC%B1%84%ED%8C%85%EC%9D%84-%EB%A7%8C%EB%93%A4-%EC%88%98-%EC%9E%88%EB%8B%A4%EA%B3%A0
 - **Java-WebRTC 참고(Kurento Media Server 사용)** - https://doc-kurento.readthedocs.io/en/6.9.0/tutorials/java/tutorial-magicmirror.html
 - **쿠렌토란** - https://scshim.tistory.com/3
# 영상
 - JanusServer(Signaling Server)와 WebRTC 기술 - https://www.youtube.com/watch?v=5U6QCttnazQ
