import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "form", "formarea", "url", "buttonsLvl1", "buttonsLvl2", "buttonsLvl3"]
  static values = {
    url: String
  }

  connect() {
    this.displayLvl1();
    // const cams = devices.filter(device => device.kind === 'videoinput');
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
    // this.width = window.screen.width *0.8;
    // this.height = window.screen.height * 0.4;

    // this.cameraScreenTarget.setAttribute("height", window.screen.height * 0.4);
    this.cameraScreenTarget.setAttribute("width", window.screen.width * 0.8);
    onpopstate = (event) => {
      this.stopPhoto();
    }
  };

  displayLvl1 () {
    this.buttonsLvl1Target.classList.remove("d-none");
    this.buttonsLvl2Target.classList.add("d-none");
    this.buttonsLvl3Target.classList.add("d-none");
  }
  displayLvl2 () {
    this.buttonsLvl1Target.classList.add("d-none");
    this.buttonsLvl2Target.classList.remove("d-none");
    this.buttonsLvl3Target.classList.add("d-none");
  }
  displayLvl3 () {
    this.buttonsLvl1Target.classList.add("d-none");
    this.buttonsLvl2Target.classList.add("d-none");
    this.buttonsLvl3Target.classList.remove("d-none");
  }

  stopPhoto () {
    if (this.stream) {
      this.stream.getTracks().forEach(track => {
        track.stop();
      });
    }
  };

  stopPhotoAndBack (event) {
    const url = event.currentTarget.dataset.url;
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
    window.location.href = url;
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
    const imgElement = document.createElement('img');
    const imageUrl = URL.createObjectURL(data);
    imgElement.src = imageUrl;
    imgElement.width = window.screen.width * 0.8;
    // imgElement.height = this.height;
    this.cameraScreenTarget.parentNode.replaceChild(imgElement, this.cameraScreenTarget);
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
    const url_photo = "/planifications/photo";
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
          let medic_id = document.querySelector("#planification_medication_id");
          let medic_name = document.querySelector(".custom-title");
          medic_id.value=data.medication.id;
          medic_name.innerHTML=data.medication.name;
          let dosage_id = document.querySelector("#planification_dosage_id");
          dosage_id.value=data.type.id;
        }
      }
    })
    .catch(error => {
      console.error('Erreur lors de la requête fetch:', error);
    });
  };


  validatePhoto(event) {
    this.displayLvl3();
    event.preventDefault();
    this.formareaTarget.classList.remove("d-none");
  };

  // retakePhoto () {
  //   this.photoAgain();
  //   this.photo();
  // };

  retakePhotoAndBack (event) {
    window.location.href = "cam";
  };

  submitForm(event) {
    event.preventDefault();
    let formData = new FormData(this.formTarget);
    formData.append("file", this.file);
    formData.delete("planification[range_date]")
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
        this.stopPhoto();
        window.location.href = `/planifications/${data.planification.id}/confirm`;
      }
    })
  }

};
