import { Controller } from "@hotwired/stimulus"
import flatpickr from 'flatpickr';

const French = {
  firstDayOfWeek: 1,
  weekdays: {
      shorthand: ["dim", "lun", "mar", "mer", "jeu", "ven", "sam"],
      longhand: [
          "dimanche",
          "lundi",
          "mardi",
          "mercredi",
          "jeudi",
          "vendredi",
          "samedi",
      ],
  },
  months: {
      shorthand: [
          "janv",
          "févr",
          "mars",
          "avr",
          "mai",
          "juin",
          "juil",
          "août",
          "sept",
          "oct",
          "nov",
          "déc",
      ],
      longhand: [
          "janvier",
          "février",
          "mars",
          "avril",
          "mai",
          "juin",
          "juillet",
          "août",
          "septembre",
          "octobre",
          "novembre",
          "décembre",
      ],
  }};

export default class extends Controller {
  static targets = ["rangeDate", "startDate", "endDate"]


  connect() {
    const startDateValue = this.startDateTarget.value;
    const endDateValue = this.endDateTarget.value;
    const defaultDates = (startDateValue && endDateValue) ? [this.parseDate(startDateValue), this.parseDate(endDateValue)] : null;
    const defaultMinDate = defaultDates ? defaultDates[0] : "today";
    flatpickr(this.rangeDateTarget, {
      mode: "range",
      minDate: defaultMinDate,
      dateFormat: "d/m/Y",
      inline: true,
      defaultDate: defaultDates,
      onChange: (selectedDates) => {
        if (selectedDates.length === 2) {
          const [startDate, endDate] = selectedDates;
          this.startDateTarget.value = this.formatDate(startDate);
          this.endDateTarget.value = this.formatDate(endDate);
        }
      },
      locale: French,
      rangeSeparator: " au ",
      weekAbbreviation: "Sem",
      scrollTitle: "Défiler pour augmenter la valeur",
      toggleTitle: "Cliquer pour basculer",
      time_24hr: true,

    })
  }


  formatDate(date) {
    const day = String(date.getDate()).padStart(2, '0');
    const month = String(date.getMonth() + 1).padStart(2, '0');
    const year = date.getFullYear();
    return `${day}/${month}/${year}`;
  }

  parseDate(date) {
    const [day, month, year] = date.split('/');
    return new Date(`${year}-${month}-${day}`);
  }
}
