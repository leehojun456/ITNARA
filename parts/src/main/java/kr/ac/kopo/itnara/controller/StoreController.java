package kr.ac.kopo.itnara.controller;

import java.io.File;
import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.ac.kopo.itnara.model.Category;
import kr.ac.kopo.itnara.model.Product;
import kr.ac.kopo.itnara.model.ProductImage;
import kr.ac.kopo.itnara.model.Store;
import kr.ac.kopo.itnara.security.CustomUserDetails;
import kr.ac.kopo.itnara.service.ProductService;
import kr.ac.kopo.itnara.service.StoreService;

@Controller
@RequestMapping("/store")
public class StoreController {

	@Autowired
	StoreService service;
	
	@Autowired
	ProductService productService;

	private String path = "store/";
	private String uploadPath = "d:/upload/";

	@GetMapping(value = { "/{userId}", "/" })
	String list(@PathVariable(required = false) Long userId, Model model) {

		Store item = service.item(userId);
		model.addAttribute("item", item);

		List<Product> list = service.list(userId);

		model.addAttribute("list", list);
		return path + "products";

	}

	@GetMapping("/{userId}/{productId}/delete")
	String delete(@PathVariable Long userId, @PathVariable Long productId, Authentication authentication) {
		
		//��ȸ�� �� ��ǰ ����ڿ� �α��������� ��ġ�� ��쿡�� ó���ǵ���
		if (isAuthenticated()) {
			CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
			if(userId == userDetails.getUserId())
			{
				//service.delete(productId);
				List<ProductImage> images = service.delete(productId);
				for(ProductImage image : images) {
					File file = new File(uploadPath + image.getUuid() + "_" + image.getImageName());
					file.delete();
				}
			}
		}
		return "redirect:/";
	}
	
	@GetMapping("/{userId}/{productId}/update")
	String update(@PathVariable Long userId, @PathVariable Long productId, Authentication authentication, Model model, Product item) {
		
		//��ȸ�� �� ��ǰ ����ڿ� �α��������� ��ġ�� ��쿡�� ó���ǵ���
		if (isAuthenticated()) {
			CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
			if(userId == userDetails.getUserId())
			{
				List<Category> categoryList = productService.category();
				model.addAttribute("category",categoryList);
				item = service.product(productId);
				model.addAttribute("item",item);
				return path + "product/update";
			}
		}
		return "redirect:/";
	}
	
	@PostMapping("/{userId}/{productId}/update")
	String update(@PathVariable Long userId, @PathVariable Long productId, Product item)
	{
		if (isAuthenticated()) {
			item.setProductId(productId);
			service.update(item);
		}
		return "redirect:/"+path +  userId + "/" + productId;
		
	}
	

	@GetMapping("/{userId}/{productId}")
	String Detail(@PathVariable Long productId, Model model) {

		Product item = service.product(productId);
		model.addAttribute("product", item);

		return path + "detail";
	}

	private boolean isAuthenticated() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
			return false;
		}
		return authentication.isAuthenticated();
	}
}
