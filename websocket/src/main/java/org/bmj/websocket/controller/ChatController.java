package org.bmj.websocket.controller;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class ChatController {

	@RequestMapping(value = { "/", "/index" })
	public String index() {
		return "index";
	}
	
	//@SendTo : 브로드캐스팅
	//@SendToUser : 유니캐스팅
	
	@MessageMapping("/queue/chat")
	@SendTo("/topic/chat")
	private String sadfasdf(String msg) {
		return msg;
	}
	
	/*
	@MessageMapping("/queue/chat")
	@SendTo("/topic/chat")
	public Protocol sfasds(Protocol protocol, SimpMessageHeaderAccessor accessor) {
		return protocol;
	}
	
	@MessageMapping("/queue/hello")
	@SendTo("/topic/hello")
	public Protocol asdassadf(Protocol protocol, SimpMessageHeaderAccessor accessor) {
		return protocol;
	}
	
	@MessageMapping("/queue/bye")
	@SendTo("/topic/bye")
	public Protocol asdadsfasdfssadf(Protocol protocol, SimpMessageHeaderAccessor accessor) {
		return protocol;
	}
	*/


}
