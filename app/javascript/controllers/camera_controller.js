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
    })
    .catch(function(err) {
      console.log("Erreur lors de l'initilisaztion de l'appareil photo : " + err);
    });

    this.cameraScreenTarget.setAttribute("height",230);
    this.cameraScreenTarget.setAttribute("width",300);
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
    const width = 300;
    const height = 230;
    var context = canvas.getContext('2d');
    canvas.width = width;
    canvas.height = height;
    context.drawImage(this.cameraScreenTarget, 0, 0, width, height);
    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/jpeg');
    });
    this.file = new File([data], 'medic_photo.jpg',{ type: 'image/jpeg' });
    this.convertToBase64(this.file)
    const imgElement = document.createElement('img');
    const imageUrl = URL.createObjectURL(data);
    imgElement.src = imageUrl;
    imgElement.width = width;
    imgElement.height = height;
    this.cameraScreenTarget.parentNode.replaceChild(imgElement, this.cameraScreenTarget);
    this.stopPhoto();
  };

  convertToBase64(file) {
    if (file) {
      this.fileToBase64(file).then(base64 => {
        // this.outputTarget.textContent = base64;
        console.log('Fichier converti en base64 :', base64);
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
