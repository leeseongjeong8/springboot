<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>까까오톡</title>
    <link rel="stylesheet" href="/css/reset.css"/>
    <link rel="stylesheet" href="/css/all.min.css">
    <link rel="stylesheet" href="/css/notosanskr.css" />
    <link rel="stylesheet" href="/css/chat.css" />
    <link rel="icon" href="/img/favicon.jpg" />
</head>
<body>
<div id="chattingSection" class="close">
    <h1><i class="far fa-comment-dots"></i> 까까오톡</h1>
    <div id="loginBox">
        <form action="" id="loginForm">
            <fieldset>
                <legend class="screen_out">로그인폼</legend>
            <div class="row">
                <h2>프로필 사진 선택</h2>
                <input id="profile1" type="radio" class="radio" name="profile" value="1" />
                <label class="profile" for="profile1">
                    <img src="profile/1.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile2" type="radio" class="radio" name="profile" value="2" />
                <label class="profile" for="profile2">
                    <img src="profile/2.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile3" type="radio" class="radio" name="profile" value="3" />
                <label class="profile" for="profile3">
                    <img src="profile/3.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile4" type="radio" class="radio" name="profile" value="4" />
                <label class="profile" for="profile4">
                    <img src="profile/4.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile5" type="radio" class="radio" name="profile" value="5" />
                <label class="profile" for="profile5">
                    <img src="profile/5.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile6" type="radio" class="radio" name="profile" value="6" />
                <label class="profile" for="profile6">
                    <img src="profile/6.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile7" type="radio" class="radio" name="profile" value="7" />
                <label class="profile" for="profile7">
                    <img src="profile/7.jpg" />
                    <i class="fas fa-check"></i>
                </label>
                <input id="profile8" type="radio" class="radio" name="profile" value="8" />
                <label class="profile" for="profile8">
                    <img src="profile/8.jpg" />
                    <i class="fas fa-check"></i>
                </label>
            </div>
            <div class="row">
                <h2>닉네임 입력</h2>
                <label for="nickname" class="screen_out">닉네임</label>
                <input size="5" maxlength="5" placeholder="1~5글자로 닉네임을 입력" id="nickname" name="nickname">
            </div>
            <div class="row">
            <button class="btn" id="loginBtn"><i class="fas fa-sign-in-alt"></i> 접속</button>
            </div>
            </fieldset>
        </form>
    </div><!-- #loginBox -->
    <div id="chatList">
        <h3 class="screen_out" >채팅목록</h3>
        <button class="btn" id="closeBtn"><i class="far fa-times-circle"></i> 접속종료</button>
        <div id="chatListWrap">
        <ul>
			
        </ul>
        </div><!--//#chatListWrap -->
    </div><!--//#chatList -->
    <div id="inputChatBox">
        <form id="msgForm" action=" " method="post">
            <fieldset>
                <legend class="screen_out">메세지 입력폼</legend>
                <label for="msg" class="screen_out">메세지 입력</label>
                <input name="message" autocomplete="off" id="msg" type="text" placeholder="메세지를 입력해주세요"/>
                <button id="inputBtn" class="btn" type="submit">입력</button>
            </fieldset>
        </form>
    </div><!--//#inputChatBox -->
</div><!--//#chattingSection -->

<script type="text/template" id="msgTmp">
    <li class="<@ if(mySessionId==sessionId){@>mine<@}@>">
        <div class="card_user">
            <img src="/profile/<@=profile@>.jpg" title="<@=nickname@>">
            <strong><@=nickname@></strong>
        </div>
        <div class="box_chat">
            <div class="comments"><@=msg@></div>
        </div><!--//box_reply-->
    </li>
</script>
<script type="text/template" id="helloTmp">
	 <li class="cmd">
     	<img src="/profile/<@=profile@>.jpg" title="<@=nickname@>">
     	<span><@=nickname@>님이 들어오셨습니다.</span>
 	</li>
</script>
<script type="text/template" id="byeTmp">
	 <li class="cmd">
     	<img src="/profile/<@=profile@>.jpg" title="<@=nickname@>">
     	<span><@=nickname@>님이 나가셨습니다.</span>
 	</li>
</script>

<script src="/js/jquery.js"></script>
<script src="/js/sockjs.min.js"></script>
<script src="/js/stomp.min.js"></script>
<script src="/js/underscore-min.js"></script>
<script src="/js/moment-with-locales.js"></script>
<script>

    moment.locale("ko");
    _.templateSettings = {interpolate: /\<\@\=(.+?)\@\>/gim,evaluate: /\<\@([\s\S]+?)\@\>/gim,escape: /\<\@\-(.+?)\@\>/gim};

    const msgTmp = _.template($("#msgTmp").html());
	const helloTmp = _.template($("#helloTmp").html());
	const byeTmp = _.template($("#byeTmp").html());
    
    const $chttingSection = $("#chattingSection");
    const $closeBtn = $("#closeBtn");
    const $loginBox = $("#loginBox");
    const $nickname = $("#nickname");
    const $loginForm = $("#loginForm");
    const $chatList = $("#chatList ul");
	const $chatListWrap = $("#chatListWrap");
	
	const $msgForm = $("#msgForm");
	const $msg = $("#msg");
	
	let	socket	=	null;
	let stompClient	=	null;
	
	let mySessionId = null;
	let profile = null;
	let nickname = null;

    const nicknameExp = /^[가-힣|\w]{1,5}$/;
    
    
    $loginForm.submit(function(e) {
		e.preventDefault();

		profile = $(":checked").val();

		if (!profile) {
			alert("프로필 사진을 반드시 선택해주세요.");
			return;
		}

		nickname = $nickname.val().trim();

		if (!nicknameExp.test(nickname)) {
			alert("닉네임을 반드시 1~5자로 입력해주세요.");
			$nickname.val("").focus();
			return;
		}

		$chttingSection.removeClass("close");

	});
	
	$loginBox.on("transitionend", function(e) {

		if (e.originalEvent.propertyName == "left") {
			if ($chttingSection.hasClass("close")) {
				
				stompClient.disconnect();
				socket.close();
				socket=null;
				stompClient = null;

				$(":checked").prop("checked", false);
				$nickname.val("");
				
				$chatList.empty();
				
			} else {
				//열렸음
				connect();

			}//if~else end
		}//if end
	});

	$closeBtn.on("click", function() {
		
		//stompClient.send("/queue/bye", {}, JSON.stringify({"profile":profile,"nickname":nickname}));

		$chttingSection.addClass("close");
	});

	//메세지 입력했을때
	$msgForm.submit(function(e) {
		
		e.preventDefault();

		const msg = $msg.val().trim();

		if (msg.length==0) {
			alert("메세지를 입력해주세요.");
			return;
		}//if end
		
		//메세지를 입력하면	
		stompClient.send("/queue/chat",{},
				JSON.stringify({
					nickname:nickname,
					profile:profile,
					msg:msg,
					sessionId:mySessionId
					}));
		
		$msg.val("").focus();
		
	});

	function connect() {
		
		//웹소캣
		socket	=	new	SockJS('/chat');
		//스톰프 업그레이드
		stompClient	= Stomp.over(socket);
		
		//연결
		stompClient.connect({},function(msg)	{
			
			//내 세션아이디 얻어서 전역변수 mySessionId에 저장
			const url = socket._transport.url;
			mySessionId = url.substring(url.lastIndexOf('/',url.length-11)+1,url.lastIndexOf('/'));
			
			//전체 채팅 구독
			stompClient.subscribe("/topic/chat",function(msg) {
				
				$chatList.append(msgTmp(JSON.parse(msg.body)));
				moveScroll();
				
			});
			
			//stompClient.send(주소,헤더,메세지);
			
			//topic : 브로드캐스팅(여러곳에)
			//queue : 유니캐스팅(한 곳에)
			
			//stompClient.send("/queue/test",{},"안녕하세요?");
			
			/*
			const url = socket._transport.url;
			
			mySessionId = url.substring(url.lastIndexOf('/',url.length-11)+1,url.lastIndexOf('/'));
			
			console.log("mySessionId:"+mySessionId);
			
			//전체 채팅
			stompClient.subscribe("/topic/chat", function(msg) {
				
				$msg.val("").focus();
		    	 $chatList.append(msgTmp(JSON.parse(msg.body)));
		    	 moveScroll();
			});
			
			//처음들어왔을때
			stompClient.subscribe("/topic/hello", function(msg) {
				$msg.val("").focus();
		    	 $chatList.append(helloTmp(JSON.parse(msg.body)));
		    	 moveScroll();
			});
			
			//나갈때
			stompClient.subscribe("/topic/bye", function(msg) {
				$msg.val("").focus();
		    	 $chatList.append(byeTmp(JSON.parse(msg.body)));
		    	 moveScroll();
			});
			
			stompClient.send("/queue/hello", {}, JSON.stringify({"profile":profile,"nickname":nickname}));
			
			*/
			
		});
		
	}//connect end
	
	//스크롤 자동으로 아래로
	function moveScroll() {
		setTimeout(function() {
			$chatListWrap.scrollTop($chatList.height());
			$msg.focus();
		},10);
	}

</script>
</body>
</html>