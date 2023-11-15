package kr.ac.kopo.itnara.controller;

import java.security.Principal;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import kr.ac.kopo.itnara.model.User;
import kr.ac.kopo.itnara.service.UserService;

@Controller
public class RootController {

	@Autowired
	UserService userService;

	@GetMapping("/")
	String index(Model model, Principal principal) {
		return "index";
	}


	@GetMapping("/auth/login")
	String login(HttpSession session) {
		if (isAuthenticated()) {
			return "redirect:/";
		}
		else
		{
			return "/auth/login";
		}
	}

	@GetMapping("/auth/signup")
	String register() {
		return "/auth/signup";
	}

	@PostMapping("/signup")
	String signup(User item) {
		userService.Register(item);
		return "redirect:/";
	}

	@GetMapping("/logout")
	String logout(HttpSession session, HttpServletRequest request) {
		session.invalidate();

		return "redirect:" + request.getHeader("Referer");
	}

	private boolean isAuthenticated() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
			return false;
		}
		return authentication.isAuthenticated();
	}
}
