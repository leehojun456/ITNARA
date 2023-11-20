<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<script src="/js/add_files.js"></script>
<script src="/js/category.js"></script>
<meta name="_csrf" content="${_csrf.token}" />
<meta name="_csrf_header" content="${_csrf.headerName}" />
<title>Document</title>
</head>
<body>
	<jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
	<div class="container">
		<div>
			<h3>상품 등록</h3>
		</div>
		<form method="post" enctype="multipart/form-data">
			<div>
				<div class="form-group mt-2">
					<label>상품명:</label> <input type="text" name="productName"
						value="${item.productName}" />
				</div>

				<div>
					<label>카테고리1:</label><select id="category1" name="name"
						onchange="getCategory()">
						<c:forEach var="category" items="${category}">
							<c:choose>
								<c:when test="${ item.name == category.name}">
									<option value="${category.name}" selected="selected">
										${category.name}</option>
								</c:when>
								<c:otherwise>
									<option value="${category.name}">${category.name}</option>
								</c:otherwise>
							</c:choose>
						</c:forEach>
					</select>
				</div>
				<div>
					<label>카테고리2:</label> <select id="category2" name="name2" onclick="getCategory()">
							<option value="${item.name2}">${item.name2}</option>
					</select>
				</div>

				<div>
					<label>가격:</label> <input type="number" name="productPrice"
						value="${item.productPrice}" />
				</div>

				<div>
					<label>수량:</label> <input type="number" name="productStock"
						value="${item.productStock}" />
				</div>

				<div>
					<label>상태:</label> <input type="radio" name="productStatus"
						value="0" checked />새상품 <input type="radio" name="productStatus"
						value="1" />중고
				</div>

				<div>
					<label>상세 설명:</label>
					<div>
						<textarea id="summernote" name="productDetail">
${item.productDetail}</textarea>
					</div>
				</div>

				<div class="mt-2">
					<label class="col-1">제품 이미지:</label>
					<button type="button" class="btn btn-sm btn-primary" id="add">
						파일 추가</button>
					<ul id="files" class="col">
						<li class="mt-2 row">
							<div class="col-1"></div>
							<div class="col">
								<input name="uploadFile" type="file" class="form-control" />
							</div>
						</li>
					</ul>
				</div>
				<input type="hidden" name="${_csrf.parameterName}"
					value="${_csrf.token}" />
				<div>
					<button>등록</button>
					<a href="list">취소</a>
				</div>
			</div>
		</form>
	</div>
</body>
</html>