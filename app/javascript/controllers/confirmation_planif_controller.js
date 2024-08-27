import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="confirmation-planif"
export default class extends Controller {
  static values = {
    urlCancel: String,
    urlConfirm: String
  }

  connect() {
    console.log("Confirmation controller is in tha place!")
  }
  cancel () {
    window.location.href = this.urlCancelValue;
  }

  confirm () {
    window.location.href = this.urlConfirmValue;
  }

}
