document.addEventListener("DOMContentLoaded", function() {
    let parentCategory = document.getElementById("parent_category");
    let childCategory = document.getElementById("child_category");
    let grandchildCategory = document.getElementById("grandchild_category");
  
    // 親カテゴリが変更された時
    parentCategory.addEventListener("change", function() {
      let parentId = parentCategory.value;
      childCategory.innerHTML = '<option value="">選択してください</option>'; // 初期化
      grandchildCategory.innerHTML = '<option value="">選択してください</option>'; // 初期化
      if (parentId === "") return;
  
      fetch(`/categories/children?parent_id=${parentId}`)
        .then(response => response.json())
        .then(data => {
          data.forEach(child => {
            let option = document.createElement("option");
            option.value = child.id;
            option.textContent = child.name;
            childCategory.appendChild(option);
          });
        });
    });
  
    // 子カテゴリが変更された時
    childCategory.addEventListener("change", function() {
      let childId = childCategory.value;
      grandchildCategory.innerHTML = '<option value="">選択してください</option>'; // 初期化
      if (childId === "") return;
  
      fetch(`/categories/children?parent_id=${childId}`)
        .then(response => response.json())
        .then(data => {
          data.forEach(grandchild => {
            let option = document.createElement("option");
            option.value = grandchild.id;
            option.textContent = grandchild.name;
            grandchildCategory.appendChild(option);
          });
        });
    });
  });
  