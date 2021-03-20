package org.bmj.websocket.vo;

import lombok.Getter;
import lombok.Setter;

public class Protocol {
	
	private String nickname, profile, msg, sessionId;

	
	public Protocol() {
		// TODO Auto-generated constructor stub
	}


	public String getNickname() {
		return nickname;
	}


	public void setNickname(String nickname) {
		this.nickname = nickname;
	}

	public String getProfile() {
		return profile;
	}

	public void setProfile(String profile) {
		this.profile = profile;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

	public String getSessionId() {
		return sessionId;
	}

	public void setSessionId(String sessionId) {
		this.sessionId = sessionId;
	}
}
