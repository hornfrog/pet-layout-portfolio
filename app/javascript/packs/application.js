// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "./category_select.js";
import "../image_preview.js";

Rails.start()
ActiveStorage.start()

document.addEventListener("DOMContentLoaded", function() {
  document.querySelectorAll(".dropdown > a").forEach(function(element) {
    element.addEventListener("click", function(event) {
      let submenu = this.nextElementSibling;
      if (submenu) {
        submenu.classList.toggle("active");
        event.stopPropagation();
      }
    });
  });
});

  