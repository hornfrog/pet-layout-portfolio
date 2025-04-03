document.addEventListener("DOMContentLoaded", function() {
  function setupCategorySelect(parentSelector, childSelector, grandchildSelector, hiddenChild, hiddenGrandchild) {
    let parentCategory = document.querySelector(parentSelector);
    let childCategory = document.querySelector(childSelector);
    let grandchildCategory = document.querySelector(grandchildSelector);

    let hiddenChildInput = document.querySelector(hiddenChild);
    let hiddenGrandchildInput = document.querySelector(hiddenGrandchild);

    if (!parentCategory) return;

    function resetSelect(selectElement) {
      selectElement.innerHTML = '<option value="">選択してください</option>';
    }

    function fetchCategories(url, selectElement) {
      fetch(url)
        .then(response => response.json())
        .then(data => {
          data.forEach(item => {
            let option = document.createElement("option");
            option.value = item.id;
            option.textContent = item.name;
            selectElement.appendChild(option);
          });
          selectElement.dispatchEvent(new Event("change"));
        })
        .catch(error => console.error("カテゴリの取得に失敗しました:", error));
    }

    parentCategory.addEventListener("change", function() {
      let parentId = parentCategory.value;
      resetSelect(childCategory);
      resetSelect(grandchildCategory);
      hiddenChildInput.value = "";
      hiddenGrandchildInput.value = "";

      if (parentId === "") return;
      fetchCategories(`/categories/children?parent_id=${parentId}`, childCategory);
    });

    childCategory.addEventListener("change", function() {
      let childId = childCategory.value;
      resetSelect(grandchildCategory);
      hiddenChildInput.value = childId;
      hiddenGrandchildInput.value = "";

      if (childId === "") return;
      fetchCategories(`/categories/children?parent_id=${childId}`, grandchildCategory);
    });

    grandchildCategory.addEventListener("change", function() {
      let grandchildId = grandchildCategory.value;
      hiddenGrandchildInput.value = grandchildId;
    });

    setTimeout(() => {
      if (parentCategory.value) {
        parentCategory.dispatchEvent(new Event("change"));
      }
    }, 300);
  }

  setupCategorySelect("#search_parent_category", "#search_child_category", "#search_grandchild_category", "#hidden_child_category", "#hidden_grandchild_category");
});
