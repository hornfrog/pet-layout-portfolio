document.addEventListener("DOMContentLoaded", function() {
  let parentCategory = document.getElementById("parent_category");
  let childCategory = document.getElementById("child_category");
  let grandchildCategory = document.getElementById("grandchild_category");

  if (!parentCategory) return;

  let selectedChild = childCategory.dataset.selected;
  let selectedGrandchild = grandchildCategory.dataset.selected;

  parentCategory.addEventListener("change", function() {
      let parentId = parentCategory.value;
      childCategory.innerHTML = '<option value="">選択してください</option>';
      grandchildCategory.innerHTML = '<option value="">選択してください</option>';
      if (parentId === "") return;

      fetch(`/categories/children?parent_id=${parentId}`)
          .then(response => response.json())
          .then(data => {
              data.forEach(child => {
                  let option = document.createElement("option");
                  option.value = child.id;
                  option.textContent = child.name;
                  if (child.id == selectedChild) option.selected = true;
                  childCategory.appendChild(option);
              });

              if (selectedChild) {
                  setTimeout(() => {
                      childCategory.dispatchEvent(new Event("change"));
                  }, 100);
              }
          });
  });

  childCategory.addEventListener("change", function() {
      let childId = childCategory.value;
      grandchildCategory.innerHTML = '<option value="">選択してください</option>';
      if (childId === "") return;

      fetch(`/categories/children?parent_id=${childId}`)
          .then(response => response.json())
          .then(data => {
              data.forEach(grandchild => {
                  let option = document.createElement("option");
                  option.value = grandchild.id;
                  option.textContent = grandchild.name;
                  if (grandchild.id == selectedGrandchild) option.selected = true;
                  grandchildCategory.appendChild(option);
              });
          });
  });

  setTimeout(() => {
      if (parentCategory.value) {
          parentCategory.dispatchEvent(new Event("change"));
      }
  }, 300);
});
