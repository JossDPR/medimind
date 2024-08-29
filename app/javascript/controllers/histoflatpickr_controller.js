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
    static targets = ["rangeDate", "startDate", "endDate"];


    connect() {

      flatpickr(this.rangeDateTarget, {
        mode: "range",
        maxDate: "today",
        dateFormat: "d/m/Y",
        inline: true,
        onChange: function(selectedDates, dateStr, instance) {
          if (selectedDates.length === 1) {
              const date = selectedDates[0];

              // Calcul du premier jour de la semaine (lundi)
              const startOfWeek = new Date(date);
              startOfWeek.setDate(date.getDate() - date.getDay() + 1);

              // Calcul du dernier jour de la semaine (dimanche)
              const endOfWeek = new Date(startOfWeek);
              endOfWeek.setDate(startOfWeek.getDate() + 6);

              // Mise à jour de la sélection pour inclure toute la semaine
              instance.setDate([startOfWeek, endOfWeek]);

              // console.log(startOfWeek);
              // console.dir(this.rangeDateTarget);
              this.startDateTarget.value = startOfWeek;

              // this.endDateTarget.value = endOfWeek;

              // Soumettre le formulaire pour filtrer les enregistrements
              this.rangeDateTarget.closest('form').submit();
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

  }
