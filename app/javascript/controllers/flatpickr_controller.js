import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';

export default class extends Controller {
  connect() {
    flatpickr(this.element, {
      minDate: "today",
      dateFormat: "d-m-Y",
      "locale": {
      "firstDayOfWeek": 1
      },
    })
  }
}