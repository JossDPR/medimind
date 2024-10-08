import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera-patient"
export default class extends Controller {
  static targets= ["cameraScreen", "titlePage", "url", "buttonsLvl1", "buttonsLvl2", "buttonsLvl3", "buttonsLvl4", "takeInfo", "otherMedic"]
  static values = {
    takeId: String
  }

  connect() {
    this.displayLvl1();
    // prod et demo
    // this.constraint = { video: { facingMode: { exact:'environment'}}, audio: false };
    // ordi : changer pour this.constraint de prod et demo
    this.constraint= { video: true, audio: false };

    navigator.mediaDevices.getUserMedia(this.constraint)
    .then(stream => {
      this.stream=stream;
      this.cameraScreenTarget.srcObject = stream;
      this.cameraScreenTarget.play();
      const tracks = stream.getTracks();
      // this.cameraScreenTarget.onloadedmetadata = () => {
      //   this.width = this.cameraScreenTarget.videoWidth;
      //   this.height = this.cameraScreenTarget.videoHeight;
      //   console.log(`Camera screen size: ${videoWidth}x${videoHeight}`);
      // };
    })
    .catch(function(err) {
      console.log("Erreur lors de l'initilisaztion de l'appareil photo : " + err);
    });

    this.cameraScreenTarget.setAttribute("width", window.screen.width * 0.8);
    onpopstate = (event) => {
      this.stopPhoto();
    }
  };


  displayLvl1 () {
    this.buttonsLvl1Target.classList.remove("d-none");
    this.buttonsLvl2Target.classList.add("d-none");
    this.buttonsLvl3Target.classList.add("d-none");
    this.buttonsLvl4Target.classList.add("d-none");
  }
  displayLvl2 () {
    this.buttonsLvl1Target.classList.add("d-none");
    this.buttonsLvl2Target.classList.remove("d-none");
    this.buttonsLvl3Target.classList.add("d-none");
    this.buttonsLvl4Target.classList.add("d-none");
  }
  displayLvl3 () {
    this.buttonsLvl1Target.classList.add("d-none");
    this.buttonsLvl2Target.classList.add("d-none");
    this.buttonsLvl3Target.classList.remove("d-none");
    this.buttonsLvl4Target.classList.add("d-none");
  }
  displayLvl4 () {
    this.buttonsLvl1Target.classList.add("d-none");
    this.buttonsLvl2Target.classList.add("d-none");
    this.buttonsLvl3Target.classList.add("d-none");
    this.buttonsLvl4Target.classList.remove("d-none");
  }

  stopPhoto () {
    if (this.stream) {
      this.stream.getTracks().forEach(track => {
        track.stop();
      });
    }
  };

  stopPhotoAndBack (event) {
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
    window.location.href = "/";
  };

  photo = async () => {
    this.displayLvl2();

    const canvas = document.createElement('canvas');
    this.width = this.cameraScreenTarget.videoWidth;
    this.height= this.cameraScreenTarget.videoHeight;
    var context = canvas.getContext('2d');
    canvas.width = this.width;
    canvas.height = this.height;
    context.drawImage(this.cameraScreenTarget, 0, 0, this.width, this.height);
    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/jpeg');
    });
    this.file = new File([data], 'medic_photo.jpg',{ type: 'image/jpeg' });
    this.convertToBase64(this.file)
    this.imgElement = document.createElement('img');
    const imageUrl = URL.createObjectURL(data);
    this.imgElement.src = imageUrl;
    this.imgElement.width = window.screen.width * 0.8;
    // this.imgElement.height = this.height;
    this.cameraScreenTarget.parentNode.replaceChild(this.imgElement, this.cameraScreenTarget);
    this.stopPhoto();
  };

  convertToBase64(file) {
    if (file) {
      this.fileToBase64(file).then(base64 => {
        this.sendPhoto(base64);
      }).catch(error => {
        console.error('Erreur lors de la conversion en base64 :', error);
      });
    }
  };

  fileToBase64(file) {
    return new Promise((resolve, reject) => {
      const reader = new FileReader();
      reader.readAsDataURL(file);
      reader.onload = () => resolve(reader.result);
      reader.onerror = error => reject(error);
    });
  };

  sendPhoto(base64) {
    let loadingphoto = document.querySelector("#loadingphoto");
    let validatebutton = document.querySelector("#validatephoto");
    let retryphoto = document.querySelector("#retryphoto");
    validatebutton.classList.add('d-none')
    const url_photo = `/takes/${this.takeIdValue}/photo`;
    const token = document.getElementsByName('csrf-token')[0].content;
    fetch(url_photo, {
        method: "POST",
        headers: {
          'Accept': 'application/json',
          'X-CSRF-Token': token
        },
        body: base64,
    })
    .then(resp => {
      if (resp.ok) {
        return resp.json();
      } else {
        throw new Error('Erreur réseau ou serveur');
      }
    })
    .then(data => {
      if (data.errors) {
        alert(data.errors);
      } else {
        if (data.error) {
          loadingphoto.classList.add("d-none");
          validatebutton.classList.add("d-none");
          retryphoto.classList.remove("d-none");
        } else {
          loadingphoto.classList.add("d-none");
          validatebutton.classList.remove("d-none");
          retryphoto.classList.add("d-none");
          if (data.resultat.Reponse) {
            this.displayLvl4()
            this.imgElement.style.borderRadius="30px";
            this.imgElement.style.border="20px solid #50C878";
            this.imgElement.insertAdjacentHTML('beforebegin',"<h1>C'est le bon médicament</h1>");
            this.imgElement.insertAdjacentHTML('afterend',`<p>${data.resultat.Differences} </p> <p><b>Vous pouvez le prendre.</b></p>`);
            this.takeInfoTarget.classList.remove("d-none");
            this.titlePageTarget.classList.add('d-none');
          }
          else {
            this.displayLvl3()
            this.imgElement.classList.add('d-none');
            this.otherMedicTarget.classList.remove("d-none");
            this.otherMedicTarget.insertAdjacentHTML('afterbegin',`<p>${data.resultat.Differences}</p>`);
            this.otherMedicTarget.insertAdjacentHTML('beforebegin',`<h1 style="color:red">Ce n'est pas le bon médicament</h1>`);
            this.titlePageTarget.classList.add('d-none');
          }
        }
      }
    })
    .catch(error => {
      console.error('Erreur lors de la requête fetch:', error);
    });
  };


  validatePhoto(event) {
    const token = document.getElementsByName('csrf-token')[0].content;
    const url_taken = `/takes/${this.takeIdValue}/taken`;
    fetch(url_taken, {
      method: "PATCH",
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': token
      },
      body: JSON.stringify( { info: "Medication has been validated as taken" } )
    })
    .then(resp => {
      if (resp.ok) {
        return resp.json();
      } else {
        throw new Error('Erreur réseau ou serveur');
      }
    })
    .then(data => {
      if (data.errors) {
        alert(data.errors);
      } else {
        window.location.href = "/";
      }
    })
  };

  retakePhoto () {
    location.reload()
    };
}
