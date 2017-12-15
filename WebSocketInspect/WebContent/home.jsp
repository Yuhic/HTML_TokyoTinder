<%@ page language="java" contentType="text/html; charset=Windows-31J" pageEncoding="Windows-31J"%>
<%@ page import="models.MessageEntity"%>
<%@ page import="models.ProfileEntity"%>
<%@ page import="models.MatchUserEntity"%>
<%@ page import="models.TinderDao"%>
<%@ page import="java.util.ArrayList"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=Windows-31J">
<LINK REL="stylesheet" TYPE="text/css" HREF="css/style1.css">
<%
	String state = (String) session.getAttribute("state");
	TinderDao dao = new TinderDao();
	ProfileEntity self = (ProfileEntity) session.getAttribute("self");
	ProfileEntity ent = null;
	if (state.equals("home") || state.equals("judge")) {
		ent = (ProfileEntity) request.getAttribute("random");
	}
%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
<script type="text/javascript" src="WebSocketInspect.js"></script>
<script>
	/* マウスオーバー */

	/* ホップアップ確認 */
	$(function() {
		$('.logout').click(function() {
			if (!confirm('本当によろしいですか？')) {
				/* キャンセルの時の処理 */
				return false;
			} else {
				/*　OKの時の処理 */
				alert('しました');
				location.href = 'index.html';
			}
		});
	});
	/* メッセージ画面表示 */
<%if (state.equals("message")) {%>
	$(function() {
		$('.someOne').hide(0);
		$('document').ready(function() {
			$('.message').show(0);
			$('.message').animate({
				left :"0"
			}, 'fast');
		});
	});
<%}%>
	/* プロフィール画面表示 */
	function prof() {
		console.log("aaa");
		$('.someOne').fadeOut(75);
		$('.message').fadeOut(75);
		$('.profile').show(0);
		$('.profile').animate({
			left :"0"
		}, 'slow');
	};

	function editProf() {
		$('.profile').hide();
		$('.editProf').show();
	};

	function slow() {
		$('document').ready(function() {
			$('.changePass').slideDown("slow");
		});
	};

	$(function() {
		var setFileInput = $('.imgInput'), setFileImg = $('.imgView');

		setFileInput
				.each(function() {
					var selfFile = $(this), selfInput = $(this).find(
							'input[type=file]'), prevElm = selfFile
							.find(setFileImg), orgPass = prevElm.attr('src');

					selfInput
							.change(function() {
								var file = $(this).prop('files')[0], fileRdr = new FileReader();

								if (!this.files.length) {
									prevElm.attr('src', orgPass);
									return;
								} else {
									if (!file.type.match('image.*')) {
										prevElm.attr('src', orgPass);
										return;
									} else {
										fileRdr.onload = function() {
											prevElm.attr('src', fileRdr.result);
										}
										fileRdr.readAsDataURL(file);
									}
								}
							});
				});
	});

	var imgUpload = document.getElementById('imgUpload');
	imgUpload.addEventListener("change", function(e) {
		var files = e.target.files;
		for (var i = 0, file; file = files[i]; i++) {
			if (!file.type.match('image.*')) {
				// ok
				continue;
			} else {
				// ng
				alert('許可されていません');
				break;
			}
		}
	});
</script>

<title>TokyoTinder</title>
</head>
<body>
	<!-- サイドメニュー -->
	<div class="nav">
		<ul class="nl">
			<li class="myprof clearfix"><a href="javascript:void(0)" onclick="prof();">
					<div class="pic">
						<img border="0" src="./img/prof.jpg" width="40" height="40" alt="イラスト1">
					</div>
					<div class="text jikoprof">自己プロフィール</div>
			</a></li>
			<%
				//条件
				ArrayList<MatchUserEntity> m_list = dao.getMatchUser(self.getUserId());
				if (m_list != null) {
			%>
			<div id = "navHidden">
			<%
				for (MatchUserEntity m_ent : m_list) {
						int messageId = dao.getMessageId(self.getUserId(), m_ent.getUserId());
						ProfileEntity p_ent = m_ent.getEnt();
			%>
			<li class="partner clearfix"><a href="javascript:Form<%=m_ent.getUserId()%>.submit()">
					<form method="post" name="Form<%=m_ent.getUserId()%>" action="home">
						<input type="hidden" name="state" value="message">
						<input type="hidden" name="messageId" value="<%=messageId%>">
						<div class="pic">
							<img border="0" src="<%=p_ent.getImage()%>" width="40" height="40" alt="photo">
						</div>
						<div class="text">
							<div class="sidename"><%=p_ent.getName()%></div>
							<div class="sidemessage"><%=m_ent.getLatest()%></div>
						</div>
					</form>
			</a></li>
			<%
				}%></div>
				<% }else{
			%>
			<!-- マッチ相手がいない場合の表示 -->
			<li class="partner clearfix"><img border="0" src="./img/sidemenu.jpg" width="100%" height="100%" alt="イラスト1"></li>
	</div>
	<%
		}
	%>
	</ul>

	</div>

	<div id="content">
		<!-- ホーム -->
		<%
		if(state.equals("home") || state.equals("judge")){
			if (ent != null) {
		%>
		<div class="select">
			<div class="someOne">
			<div id ="r_content">
				<span class="photo"><img id="randomPhoto" border="0" src="<%=ent.getImage()%>" width="400" height="500" alt="イラスト1"></span>
				<div class="scrollHidden">
					<div class="nameAge">
						<p id="name_age">
							<span id="r_name"><%=ent.getName()%></span> <span id="r_age"><%=ent.getAge()%></span>
						</p>
					</div>
					<div class="scroll">自己PR 全力に真面目に、全力に不真面目に生きております。人生楽しくがモットーです。 今の仕事: teratailの広報 できること: 広報、営業、プロモーション企画/ディレクデョン、プログラミング（少々） 職歴: エンジニア業界の営業（約2年）、teratail広報（約10ヶ月）</div>
				</div>
				</div>
				<div class="judge">
					<div class="batsu">
						<input type="hidden" name="targetId" value="<%=ent.getUserId()%>">
						<img id="bad" border="0" src="./img/batsu.jpg" width="80" height="80" alt="×"> </a>
						</form>
					</div>
					<div class="maru">
						<img id="good" border="0" src="./img/heart.jpg" width="80" height="80" alt="〇">
					</div>
				</div>
			</div>
			<%
				} else {
			%>
			<!-- 誰もいなくなった画面 -->
			<div class="select">
				<div class="noOne">
					<div class="pink">
						<div class="pink2">
							<div class="white">
								<span class="photo"><img border="0" src="./img/prof.jpg" width="130" height="130" alt="イラスト1"></span>
							</div>
						</div>
					</div>
					<div class="scroll">
						<p id ="no_comment">そして誰もいなくなった・・・。</p>
					</div>
					<div class="judge">
						<div class="batsu">
							<img border="0" src="./img/batsu2.jpg" width="80" height="80" alt="×">
						</div>
						<div class="maru">
							<img border="0" src="./img/heart2.jpg" width="80" height="80" alt="〇">
						</div>
					</div>
				</div>
			</div>
			<%
					}
		}else if(state.equals("message")){
				%>
			<!-- メッセージ画面 -->
			<div class="message">
			<div id = "messageContent">
			<div id ="messageFlame">
				<div id ="messageNav">
				<p>彼女とは昨日マッチしました。</p>
				<p id ="messageClose">×</p>
				</div>
				<div id="messageArea">
					<%
						int id = self.getUserId();
						int message_id = 0;
						ArrayList<MessageEntity> list = (ArrayList<MessageEntity>) request.getAttribute("messageData");
						if (list != null) {
							message_id = list.get(0).getMessageId();
							for (MessageEntity msg : list) {
								if (msg.getSpeaker() == 0) {
					%>
					<div class="announce"><%=msg.getMessage()%></div>
					<%
						} else if (msg.getSpeaker() == id) {
					%>
					<div class="self"><%=msg.getMessage()%></div>
					<%
						} else {
					%>
					<div class="pair"><%=msg.getMessage()%></div>
					<%
						}
							}
						}
					%>
				</div>
				<div id = "inputArea">
					<input name="<%=self.getUserId() + ":" + message_id + ":"%>" type="text" id="messageInput" maxlength="500" />
					<p id ="messageSend">送信</p>
				</div>
			</div>
			<div id = "messageUser">
			<img id ="m_photo">
			<p id ="m_name">aaaaaa</p>
			<p id ="m_comment">iiiiiiiiiiiiii</p>
			<p id ="m_delete">マッチを解除</p>
			</div>
			</div>
<%}%>
			<!-- プロフィール画面 -->
			<div class="profile">
				<div class="profch">
					<a class="button" href="javascript:void(0)" onclick="editProf()">情報の編集</a>
				</div>
				<input type="hidden" name="UserID" value="<%=self.getUserId()%>">
				<input type="hidden" name="UserSex" value="<%=self.getSex()%>">
				<div class="profimage">
					<img id="profPhoto" border="0" src="<%=self.getImage()%>" width="400" height="500" alt="profimage">
				</div>
				<div class="profScrollHidden">
				<div class="profname"><p>
					名前:<span id="UserName"><%=self.getName()%></span> <span id="UserAge"><%=self.getAge()%></span>
				</p></div>
					<div class="profScroll">
						<h2>コメント</h2>
						<p><%=self.getComment()%>全力に真面目に、全力に不真面目に生きております。人生楽しくがモットーです。
						</p>
						<h2>base_data</h2>
						<p>
							誕生日: 1988.10.10<br> 性別:<span id="UserSex"><%=self.getSex()%></span><br> 趣味: スノボ（グラトリ専門）、バスケ<br> 特技: ビートボックス、フリースタイルバスケットボール<br>
						</p>
						<h2>work</h2>
						<p>
							今の仕事: teratailの広報<br> できること: 広報、営業、プロモーション企画/ディレクデョン、プログラミング（少々）<br> 職歴: エンジニア業界の営業（約2年）、teratail広報（約10ヶ月）
						</p>
					</div>
				</div>
				<div class="proflogout">
					<span class="logout"><a href="index.html" class="button">ログアウト</a></span>
				</div>
			</div>
			<div class="editProf">

				<p>
				<form>
					<input type=submit value="保存">

				</form>
				<div class="profimage">
					<div class="profimageInside clearfix">
						<img border="0" src="./img/prof.jpg" width="250" height="350" alt="イラスト1">

					</div>

					<div class="imgInput">
						<img border="0" src="img/no_avatar.jpg" alt="" class="imgView" width="150" height="150"> <br>
						<input type="file" name="file1" accept="image/png,image/jpeg,image/gif">

					</div>
					<p>木下雄策について紹介</p>
				</div>

				<!--/.imgInput-->

				<div class="profScroll">
					<h2>コメント</h2>
					<p>全力に真面目に、全力に不真面目に生きております。人生楽しくがモットーです。</p>
					<h2>base_data</h2>
					<p>
						誕生日: 1988.10.10<br> 性別: 男<br> 趣味: スノボ（グラトリ専門）、バスケ<br> 特技: ビートボックス、フリースタイルバスケットボール<br>
					</p>
					<h2>work</h2>
					<br> 今の仕事: teratailの広報<br> できること: 広報、営業、プロモーション企画/ディレクデョン、プログラミング（少々）<br> 職歴: エンジニア業界の営業（約2年）、teratail広報（約10ヶ月）

				</div>
				<div class="changePass">
					<label>パスワード入力 </label>
					<textarea name="content" rows="1" cols="50"></textarea>
					<br> <label>新パスワード入力 </label>
					<textarea name="content" rows="1" cols="50"></textarea>
					<br> <label>パスワード再入力 </label>
					<textarea name="content" rows="1" cols="50"></textarea>
				</div>
				<div class="changebutton">

					<div class="changePassButton">
						<a href="home.jsp?password=aa&prof1=aa" class="button2">パスワードを変更する</a>
					</div>
					<div class="changePassButton">
						<span class="logout"><a href="index.html" class="button2">アカウントを削除</a></span>
					</div>
				</div>
			</div>
		</div>
</body>
<%
	dao.close();
%>
</html>