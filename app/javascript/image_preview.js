document.addEventListener("DOMContentLoaded", function() {
  function setupImagePreview(inputId, previewId, defaultImage = null) {
    const input = document.getElementById(inputId);
    const preview = document.getElementById(previewId);

    if (!input || !preview) return;

    input.addEventListener("change", function(event) {
      const file = event.target.files[0];

      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          preview.src = e.target.result;
          preview.style.display = "block";
        };
        reader.readAsDataURL(file);
      } else if (defaultImage) {
        preview.src = defaultImage; 
      }
    });
  }

  setupImagePreview("image-input", "preview-image", "/assets/no-image.png");
  setupImagePreview("avatar-input", "avatar-preview", "/assets/no-man.png");
});
