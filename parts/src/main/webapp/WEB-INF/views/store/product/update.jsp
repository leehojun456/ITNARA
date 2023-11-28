<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%> <%@ taglib uri="http://java.sun.com/jsp/jstl/core"
prefix="c"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="_csrf" content="${_csrf.token}" />
    <meta name="_csrf_header" content="${_csrf.headerName}" />
    <title>Document</title>
  </head>
  <body>
    <jsp:include page="/WEB-INF/views/header.jsp"></jsp:include>
    <div class="container">
      <div>
        <h3>기본 정보</h3>
      </div>
      <form class="add-form" method="post" enctype="multipart/form-data">
        <div class="mt-2">
          <label class="col-1">제품 이미지:</label>
          <button type="button" class="btn btn-sm btn-primary" id="add">
            파일 추가
          </button>
          <ul id="files" class="col">
            <li class="mt-2 row">
              <div class="col-1"></div>
              <div class="col">
                <input name="uploadFile" type="file" class="form-control" />
              </div>
            </li>
          </ul>
        </div>
        <input
          type="hidden"
          name="${_csrf.parameterName}"
          value="${_csrf.token}"
        />
        <div class="inputbar">
          <input
            class="input_inner productName"
            type="text"
            name="productName"
            value="${item.productName}"
          /><label class="input_label">상품명:</label>
        </div>
        <div class="selector-box">
          <div>
            <label>카테고리1:</label>
            <select
              class="selector"
              id="category1"
              name="name"
              onchange="getCategory()"
            >
              <c:forEach var="category" items="${category}">
                <c:choose>
                  <c:when test="${category.name eq item.name}">
                    <option value="${category.name}" selected="selected">
                      ${category.name}
                    </option>
                  </c:when>
                  <c:otherwise>
                    <option value="${category.name}">${category.name}</option>
                  </c:otherwise>
                </c:choose>
              </c:forEach>
            </select>
          </div>
          <div>
            <label>카테고리2:</label>
            <select class="selector" id="category2" name="name2"></select>
          </div>
        </div>

        <div class="inputbar">
          <input
            class="input_inner price"
            type="number"
            name="productPrice"
            min="0"
            value="${item.productPrice}"
          /><label class="input_label">가격:</label>
        </div>

        <div class="inputbar productStock">
          <input
            class="input_inner"
            type="number"
            name="productStock"
            value="${item.productStock}"
          />
          <label class="input_label">수량:</label>
        </div>

        <div class="inputbar row">
          <label>상태:</label>
          <div>
            <input type="radio" name="productStatus" value="0" checked /><label
              >새상품</label
            >
          </div>
          <div>
            <input type="radio" name="productStatus" value="1" /><label
              >중고</label
            >
          </div>
        </div>

        <div>
          <div class="inputbar">
            <textarea class="input_inner" name="productDetail">
${item.productDetail}</textarea
            >
            <label class="input_label">상세 설명:</label>
          </div>
        </div>
        <div class="buttons">
          <button
            type="button"
            onclick="formUpload()"
            class="long-button c-blue"
          >
            등록
          </button>
          <a href="/" class="long-button c-gray">취소</a>
        </div>
      </form>
    </div>
  </body>

  <script>
    function formUpload() {
      var path = window.location.pathname;
      // 경로에서 userId와 productId 추출하기
      var userIdMatch = path.match(/\/store\/(\d+)\/(\d+)/);

      // userId와 productId가 존재하면 값을 추출
      const userId = userIdMatch ? userIdMatch[1] : null;
      const productId = userIdMatch ? userIdMatch[2] : null;

      const csrfHeader = document.querySelector(
        'meta[name="_csrf_header"]'
      ).content;
      const csrfToken = document.querySelector('meta[name="_csrf"]').content;

      const formData = new FormData(document.querySelector(".add-form"));
      formData.append("userId", userId);
      formData.append("productId", productId);

      console.log(formData);

      const fileInput = document.querySelector('input[name="uploadFile"]');
      if (fileInput.files.length > 0) {
        formData.append("uploadFile", fileInput.files[0]);
      }

      fetch("/api/product/update", {
        method: "POST",
        headers: {
          [csrfHeader]: csrfToken,
        },
        body: formData,
      })
        .then((resp) => resp.text())
        .then((result) => {
          history.back();
        });
    }
  </script>
  <script>
    window.addEventListener("DOMContentLoaded", () => {
      getCategory().then(() => {
        const category2 = document.getElementById("category2");

        for (const option of category2.options) {
          if (option.value == "${item.name2}") {
            option.selected = true;
            console.log(option.value);
          }
        }
      });
    });

    function getCategory() {
      return new Promise((resolve, reject) => {
        var selected = document.getElementById("category1");
        var value = selected.options[selected.selectedIndex].value;
        console.log(value);

        fetch("/api/category", {
          method: "GET",
          headers: {
            "Content-Type": "application/json",
          },
        })
          .then((resp) => {
            if (!resp.ok) {
              throw new Error(`HTTP error! Status: ${resp.status}`);
            }
            return resp.json();
          })
          .then((result) => {
            category2Change(result);
            resolve(); // fetch 성공 후 resolve 호출
          })
          .catch((error) => {
            console.error("Error:", error);
            reject(error); // 에러가 발생하면 reject 호출
          });

        function category2Change(result) {
          var selectElement = document.getElementById("category2");
          selectElement.innerHTML = "";
          for (var i = 0; i < result.length; i++) {
            var option = document.createElement("option");
            if (value == result[i].name) {
              option.value = result[i].name2;
              option.text = result[i].name2;
              selectElement.add(option);
            }
          }
        }
      });
    }
  </script>
</html>
