import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="reset-form"
export default class extends Controller {
  connect() {
    console.log('resetForm controller is in tha place!')
  }
  reset() {
    this.element.reset()
  }
}
