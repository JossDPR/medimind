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

      function getEndOfWeek(date) {
        const lastDayOfWeek = new Date(date);
        lastDayOfWeek.setDate(date.getDate() + (7 - date.getDay()));
        return lastDayOfWeek;
      }

      const today = new Date();
      const SelectendOfWeek = getEndOfWeek(today);


      flatpickr(this.rangeDateTarget, {
        mode: "range",
        maxDate: SelectendOfWeek,
        dateFormat: "d/m/Y",
        inline: true,
        onChange: (selectedDates, dateStr, instance) => {
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

              this.startDateTarget.value = startOfWeek;
              this.endDateTarget.value = endOfWeek;

              const data = {
                startDate: startOfWeek,
                endDate: endOfWeek
              };
              document.querySelector('form').submit();

              fetch(patient_patient_histo_index_path(), {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
              })
              .then(response => {
                if (!response.ok) {
                  throw new Error('Network response was not ok');
                }
                return response.json();
              })
              .then(responseData => {
                console.log('Réponse du serveur:', responseData);

              })
              .catch(error => {
                console.error('Erreur lors de la requête fetch:', error);
              });








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
