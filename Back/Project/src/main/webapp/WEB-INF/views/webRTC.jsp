<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page session="false" %>
<script type="text/javascript">

/* Tutorial
 * 1. 카메라와 마이크 뿐만 아니라 모든 스트리밍 데이터 소스에 대한 MediaStream을 활성화하는 것
 * 2. getUserMedia()는 반드시 로컬 파일 시스템이 아닌 서버에서 사용되어야하며, 이외의 경우에는 PERMISSION_DENIED: 1 에러가 발생한다
 */
function gotStream(stream) {
    window.AudioContext = window.AudioContext || window.webkitAudioContext;
    var audioContext = new AudioContext();

    // Create an AudioNode from the stream
    var mediaStreamSource = audioContext.createMediaStreamSource(stream);

    // Connect it to destination to hear yourself
    // or any other node for processing!
    mediaStreamSource.connect(audioContext.destination);
}

function userMedia(error){
	if(error){
		alert(error);
	}else{
		alert('getUserMedia Error!!');
	}
}

navigator.getUserMedia({audio:true}, gotStream, userMedia); // 카메라 마이크 접속권한 체크(?)

</script>
<html>
<head>
	<title>WebRTC</title>
</head>
<body>
	Welcome WebRTC! 

<video autoplay="autoplay">
</video>

</body>
</html>
