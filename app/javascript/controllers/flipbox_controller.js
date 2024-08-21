import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="flipbox"
export default class extends Controller {
  static targets = ["round", "flipBox", "arrow", "bRound"];

  connect() {
    this.roundTarget.addEventListener("mouseenter", this.handleHover.bind(this));
    this.roundTarget.addEventListener("mouseleave", this.handleHover.bind(this));
    this.roundTarget.addEventListener("click", this.handleClick.bind(this));
    this.roundTarget.addEventListener("transitionend", this.handleTransitionEnd.bind(this));
  }

  handleHover(event) {
    this.bRoundTarget.classList.toggle("b_round_hover");
  }

  handleClick(event) {
    // Si la boîte est déjà retournée, ne rien faire
    if (this.flipBoxTarget.classList.contains("flipped")) {
      return;
    }

    // Retourne la boîte
    this.flipBoxTarget.classList.toggle("flipped");
    this.roundTarget.classList.add("s_round_click");
    this.arrowTarget.classList.toggle("s_arrow_rotate");
    this.bRoundTarget.classList.toggle("b_round_back_hover");

    // Désactiver les événements pour éviter un autre retour à la face avant
    this.roundTarget.removeEventListener("mouseenter", this.handleHover.bind(this));
    this.roundTarget.removeEventListener("mouseleave", this.handleHover.bind(this));
    this.roundTarget.removeEventListener("click", this.handleClick.bind(this));
  }

  handleTransitionEnd(event) {
    this.roundTarget.classList.remove("s_round_click");
    this.roundTarget.classList.add("s_round_back");
  }
}
