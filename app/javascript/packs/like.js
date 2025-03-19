document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".like-button").forEach(button => {
      button.addEventListener("click", function (event) {
        event.preventDefault();
  
        let url = this.dataset.url;
        let method = this.dataset.method;
  
        fetch(url, {
          method: method,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            "Content-Type": "application/json"
          },
        })
          .then(response => response.json())
          .then(data => {
            if (data.status === "success") {
              this.dataset.method = method === "post" ? "delete" : "post";
              this.innerHTML = method === "post"
                ? `<i class="fa-solid fa-heart" style="color: red;"></i> <span class="like-count">${data.likes_count}</span>`
                : `<i class="fa-regular fa-heart"></i> <span class="like-count">${data.likes_count}</span>`;
            } else {
              alert("エラーが発生しました");
            }
          })
          .catch(error => console.error("Error:", error));
      });
    });
  });
  
  