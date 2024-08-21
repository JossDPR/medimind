// app/javascript/controllers/burger_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["navbar", "burger", "navLink"];

  connect() {
    console.log("Burger controller connected");
  }

  toggle() {
    this.navbarTarget.classList.toggle("nav-open");
    this.burgerTarget.classList.toggle("burger-open");
    this.navLinkTargets.forEach(link => {
      link.classList.toggle("nav-link-open");
    });
  }
}
