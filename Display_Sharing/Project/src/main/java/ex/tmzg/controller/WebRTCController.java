package ex.tmzg.controller;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class WebRTCController {

	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@GetMapping("/webRTC")
	public String WebRTCPage() {
		
		return "webRTC";
	}
}
