import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="edit-planification"
export default class extends Controller {
  static targets = ["form", "url"]
  static values = {
    url: String,
    cancel: String
  }
  connect() {
  }
  
  cancel () {
    window.location.href = this.cancelValue;
  }

  submitForm(event) {
    event.preventDefault();
    let formData = new FormData(this.formTarget);
    console.log(this.urlValue)
    const token = document.getElementsByName('csrf-token')[0].content
    fetch(this.urlValue, {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': token
        },
        body: formData,
    })
    .then(resp => resp.json())
    .then(data => {
      if (data.errors) {
        alert(data.errors)
      }
      else {
        window.location.href = `/patients/${data.planification.patient_id}/planifications`
      }
    })
  }
}
