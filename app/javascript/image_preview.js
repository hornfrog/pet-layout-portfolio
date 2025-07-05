document.addEventListener("DOMContentLoaded", function () {
  function setupMultipleImagePreview(inputId, containerId, maxCount = 5) {
    const input = document.getElementById(inputId);
    const container = document.getElementById(containerId);
    const removedImagesContainer = document.getElementById("removed-images-container");
    let imageFiles = [];

    if (!input || !container) return;

    container.addEventListener("click", function (event) {
      if (event.target.classList.contains("remove-image-btn")) {
        event.preventDefault();

        const wrapper = event.target.closest(".image-wrapper");
        const imageId = wrapper.dataset.imageId;

        if (imageId) {

          wrapper.remove();
          const hiddenField = document.createElement("input");
          hiddenField.type = "hidden";
          hiddenField.name = "removed_image_ids[]";
          hiddenField.value = imageId;
          removedImagesContainer.appendChild(hiddenField);
        } else {
          const wrappers = Array.from(container.querySelectorAll(".image-wrapper"));
          const index = wrappers.indexOf(wrapper);
          if (index !== -1) {
            imageFiles.splice(index, 1);
            wrapper.remove();
            updateInputFiles();
          }
        }
      }
    });

    input.addEventListener("change", function () {
      const existingCount = container.querySelectorAll(".image-wrapper[data-image-id]").length;
      const newFiles = Array.from(input.files);

      const allowableCount = maxCount - existingCount - imageFiles.length;
      const allowableFiles = newFiles.slice(0, allowableCount);

      if (newFiles.length > allowableFiles.length) {
        const alertEl = document.getElementById("alert-placeholder");
        if (alertEl) {
          alertEl.innerText = `画像は最大 ${maxCount} 枚まで選択できます。`;
          alertEl.style.display = 'block';
        }
      }

      allowableFiles.forEach((file) => {
        const reader = new FileReader();
        reader.onload = function (e) {
          const wrapper = document.createElement("div");
          wrapper.classList.add("image-wrapper");
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
          removeBtn.type = "button";
          removeBtn.textContent = "×";
          removeBtn.classList.add("remove-image-btn");
          Object.assign(removeBtn.style, {
            position: "absolute",
            top: "2px",
            right: "2px",
            background: "rgba(0,0,0,0.5)",
            color: "#fff",
            border: "none",
            borderRadius: "50%",
            cursor: "pointer",
            width: "24px",
            height: "24px",
            fontSize: "16px"
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

    input.addEventListener("change", function () {
      const file = input.files[0];
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
