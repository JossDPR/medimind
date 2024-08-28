import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';
import { French } from '/dist/l10n/fr.js';

export default class extends Controller {
  static targets = ["rangeDate", "startDate", "endDate"]

  connect() {
    flatpickr(this.rangeDateTarget, {
      mode: "range",
      minDate: "today",
      dateFormat: "d/m/Y",
      inline: true,
      onChange: (selectedDates) => {
        if (selectedDates.length === 2) {
          const [startDate, endDate] = selectedDates;
          this.startDateTarget.value = this.formatDate(startDate);
          this.endDateTarget.value = this.formatDate(endDate);
        }
      },
      locale: French,
      firstDayOfWeek: 1
    })
  }

  formatDate(date) {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

}
