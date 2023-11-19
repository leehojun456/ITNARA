package kr.ac.kopo.itnara.controller;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AnonymousAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import kr.ac.kopo.itnara.model.Product;
import kr.ac.kopo.itnara.model.ProductImage;
import kr.ac.kopo.itnara.model.Search;
import kr.ac.kopo.itnara.model.Category1;
import kr.ac.kopo.itnara.model.Category2;
import kr.ac.kopo.itnara.security.CustomUserDetails;
import kr.ac.kopo.itnara.service.ProductService;
import kr.ac.kopo.itnara.service.StoreService;

@Controller
@RequestMapping("/products")
public class ProductController {

	@Autowired
	ProductService service;

	@Autowired
	StoreService storeService;

	private String path = "/products";
	private String uploadPath = "d:/upload/";


	@GetMapping("/list")
	String list(Model model, Search search) {
		List<Product> list = service.list(search);
		model.addAttribute("list", list);
		return path + "/list";
	}
	
	
	
	@GetMapping("/new")
	String newProduct(Model model) {
		List<Category1> category1List = service.category1List();
		List<Category2> category2List = service.category2List();
		model.addAttribute("category1List",category1List);
		model.addAttribute("category2List",category2List);
		return path + "/new";
	}

	@PostMapping("/new")
	String add(Product item, List<MultipartFile> uploadFile, Authentication authentication) {
		
		

		if (isAuthenticated()) {
			List<ProductImage> images = new ArrayList<ProductImage>();
			for (MultipartFile file : uploadFile) {
				if (file.isEmpty()) {
					continue;
				}
				String filename = file.getOriginalFilename();
				String uuid = UUID.randomUUID().toString();

				try {
					file.transferTo(new File(uploadPath+uuid + "_" + filename));

					ProductImage img = new ProductImage();
					img.setImageName(filename);
					img.setUuid(uuid);

					images.add(img);
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
			CustomUserDetails userDetails = (CustomUserDetails) authentication.getPrincipal();
			item.setUserId(userDetails.getUserId());
			item.setImages(images);
			service.add(item);

			return "redirect:/";
		}
		return "/auth/login";

	}

	private boolean isAuthenticated() {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
		if (authentication == null || authentication instanceof AnonymousAuthenticationToken) {
			return false;
		}
		return authentication.isAuthenticated();
	}
}
