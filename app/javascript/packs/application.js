import Rails from "@rails/ujs"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "../modules/category_select";
import "./category_select.js";
import "../image_preview.js";
import "./like";
import './favorite';
import "sort_tabs";
import 'bootstrap'

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

  