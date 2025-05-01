document.addEventListener("DOMContentLoaded", function () {
  function setupMultipleImagePreview(inputId, containerId, maxCount = 5) {
    const input = document.getElementById(inputId);
    const container = document.getElementById(containerId);
    let imageFiles = [];

    if (!input || !container) return;

    input.addEventListener("change", function (event) {
      const newFiles = Array.from(event.target.files);

      if (imageFiles.length >= maxCount) {
        alert(`画像は最大 ${maxCount} 枚まで選択できます。`);
        return;
      }

      const allowableFiles = newFiles.slice(0, maxCount - imageFiles.length);

      allowableFiles.forEach((file) => {
        const reader = new FileReader();
        reader.onload = function (e) {
          const wrapper = document.createElement("div");
          wrapper.style.position = "relative";
          wrapper.style.display = "inline-block";
          wrapper.style.marginRight = "10px";

          const img = document.createElement("img");
          img.src = e.target.result;
          img.style.width = "150px";
          img.style.height = "150px";
          img.style.objectFit = "cover";
          img.style.borderRadius = "8px";

          const removeBtn = document.createElement("button");
          removeBtn.textContent = "×";
          removeBtn.style.position = "absolute";
          removeBtn.style.top = "2px";
          removeBtn.style.right = "2px";
          removeBtn.style.background = "rgba(0,0,0,0.5)";
          removeBtn.style.color = "#fff";
          removeBtn.style.border = "none";
          removeBtn.style.borderRadius = "50%";
          removeBtn.style.cursor = "pointer";
          removeBtn.style.width = "24px";
          removeBtn.style.height = "24px";
          removeBtn.style.fontSize = "16px";

          removeBtn.addEventListener("click", () => {
            container.removeChild(wrapper);
            imageFiles = imageFiles.filter((f) => f !== file);
            updateInputFiles();
          });

          wrapper.appendChild(img);
          wrapper.appendChild(removeBtn);
          container.appendChild(wrapper);
        };
        reader.readAsDataURL(file);
        imageFiles.push(file);
      });

      updateInputFiles();
      
    });

    function updateInputFiles() {
      const dataTransfer = new DataTransfer();
      imageFiles.forEach((file) => dataTransfer.items.add(file));
      input.files = dataTransfer.files;
    }
  }

  function setupSingleImagePreview(inputId, previewId) {
    const input = document.getElementById(inputId);
    const preview = document.getElementById(previewId);
    if (!input || !preview) return;

    input.addEventListener("change", function (event) {
      const file = event.target.files[0];
      if (!file) return;

      const reader = new FileReader();
      reader.onload = function (e) {
        preview.src = e.target.result;
      };
      reader.readAsDataURL(file);

      const removeHidden = document.getElementById("remove-avatar-hidden");
      if (removeHidden) removeHidden.value = false;
    });
  }

  function setupAvatarRemoveButton() {
    const removeBtn = document.getElementById("remove-avatar-btn");
    const avatarInput = document.getElementById("avatar-input");
    const avatarPreview = document.getElementById("avatar-preview");
    const removeHidden = document.getElementById("remove-avatar-hidden");

    if (!removeBtn || !avatarInput || !avatarPreview || !removeHidden) return;

    removeBtn.addEventListener("click", function () {
      avatarPreview.src = "/assets/no-man.png";
      avatarInput.value = "";
      removeHidden.value = true;
    });
  }

  setupMultipleImagePreview("image-input", "image-preview-container", 5);
  setupSingleImagePreview("avatar-input", "avatar-preview");
  setupAvatarRemoveButton();
});
