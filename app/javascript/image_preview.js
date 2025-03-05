document.addEventListener("DOMContentLoaded", function() {
    const imageInput = document.getElementById("image-input");
    const previewImage = document.getElementById("preview-image");
  
    if (!imageInput || !previewImage) return;
  
    imageInput.addEventListener("change", function(event) {
      const file = event.target.files[0];
  
      if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
          previewImage.src = e.target.result;
          previewImage.style.display = "block";
        };
        reader.readAsDataURL(file);
      } else {
        previewImage.src = "#";
        previewImage.style.display = "none";
      }
    });
  });  
