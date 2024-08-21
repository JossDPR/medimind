import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="expand"
export default class extends Controller {
  static targets = ["card"];

  connect() {
    console.log('Expand controller connected')
    this.zindex = 10;
  }

  toggle(event) {
    event.preventDefault();

    const card = event.currentTarget;
    const isShowing = card.classList.contains("show");

    if (this.element.classList.contains("showing")) {
      // Une carte est déjà affichée
      const showingCard = this.element.querySelector(".card.show");
      if (showingCard) {
        showingCard.classList.remove("show");
        this.resetNextCard(showingCard);  // Réinitialiser la carte suivante
      }

      if (isShowing) {
        // Cette carte est déjà affichée - réinitialiser la grille
        this.element.classList.remove("showing");
      } else {
        // Cette carte n'est pas affichée - la montrer
        card.style.zIndex = this.zindex;
        card.classList.add("show");
        this.shiftNextCard(card);  // Décaler la carte suivante
        this.zindex++;
      }
    } else {
      // Aucune carte n'est affichée
      this.element.classList.add("showing");
      card.style.zIndex = this.zindex;
      card.classList.add("show");
      this.shiftNextCard(card);  // Décaler la carte suivante
      this.zindex++;
    }
  }

  shiftNextCard(card) {
    // Trouver la carte suivante
    const nextCard = card.nextElementSibling;
    if (nextCard && nextCard.classList.contains("card")) {
      nextCard.style.transform = "translateY(20px)"; // Décale la carte suivante vers le bas
    }
  }

  resetNextCard(card) {
    // Réinitialiser la transformation de la carte suivante
    const nextCard = card.nextElementSibling;
    if (nextCard && nextCard.classList.contains("card")) {
      nextCard.style.transform = "translateY(0)"; // Remet la carte suivante à sa position d'origine
    }
  }

}
