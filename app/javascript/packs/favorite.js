document.addEventListener("DOMContentLoaded", function () {
    document.querySelectorAll(".favorite-button").forEach(button => {
      button.addEventListener("click", function (event) {
        
        if (this.classList.contains("guest-user")) {
          event.preventDefault();
          alert("お気に入りに追加する場合は、ログインまたは会員登録をしてください。");
          return;
        }
  
        event.preventDefault();
        const url = this.dataset.url;
        const method = this.dataset.method;
  
        fetch(url, {
          method: method,
          headers: {
            "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
            "Content-Type": "application/json"
          }
        })
        .then(response => {
          return response.json().then(data => {
            if (!response.ok) {
              throw new Error(data.message || "エラーが発生しました");
            }
            return data;
          });
        })
        .then(data => {
          alert(data.message);
          if (data.status === "success") {
            this.dataset.method = method === "post" ? "delete" : "post";
            this.innerHTML = method === "post"
              ? `<i class="fa-solid fa-star" style="color: gold;"></i>`
              : `<i class="fa-regular fa-star"></i>`;
          }
        })
        .catch(error => {
            console.error("Error:", error.message);
          });
      });
    });
  });
  
  