function bindFavoriteButtons() {
  document.querySelectorAll(".favorite-button").forEach(button => {
    const newButton = button.cloneNode(true);
    button.replaceWith(newButton);

    newButton.addEventListener("click", function (event) {
      if (this.classList.contains("guest-user")) {
        event.preventDefault();
        alert("お気に入りに追加するには、ログインまたは会員登録をしてください。");
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
      .then(response => response.json())
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
}

document.addEventListener("DOMContentLoaded", bindFavoriteButtons);
window.bindFavoriteButtons = bindFavoriteButtons;
