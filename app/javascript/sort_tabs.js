document.addEventListener("DOMContentLoaded", function () {
  document.body.addEventListener("click", function (event) {
    const button = event.target.closest(".sort-tab");
    if (!button) return;

    event.preventDefault();
    const sortType = button.getAttribute("data-sort");
    const url = new URL(window.location.href);
    url.searchParams.set("sort", sortType);

    fetch(url, {
      headers: {
        "X-Requested-With": "XMLHttpRequest",
        "Accept": "application/json"
      }
    })
      .then(response => response.json())
      .then(data => {
        const target = document.querySelector("#recipes-list");
        const countDisplay = document.querySelector("#recipe-count");

        if (target) {
          target.innerHTML = data.html;

          if (window.bindLikeButtons) window.bindLikeButtons();
          if (window.bindFavoriteButtons) window.bindFavoriteButtons();
        }

        if (countDisplay) {
          countDisplay.textContent = `投稿件数: ${data.count} 件`;
        }
      })
      .catch(error => console.error("Error:", error));
  });
});
  

  