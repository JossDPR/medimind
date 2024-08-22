import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "cameraButton", "form", "buttonValidate"]
  static values = {
    url: String
  }

  connect() {
    console.log("Camera controller is in tha place!");

    navigator.mediaDevices.getUserMedia({ video: true, audio: false })
    .then(stream => {
      this.stream=stream
      this.cameraScreenTarget.srcObject = stream;
      this.cameraScreenTarget.play();
      const tracks = stream.getTracks();
    })
    .catch(function(err) {
      console.log("An error occurred: " + err);
    });
    this.cameraScreenTarget.setAttribute("height",400);
    this.cameraScreenTarget.setAttribute("width",400);
  };

  photoAgain () {
    console.log("Camera controller is in tha place!");

    navigator.mediaDevices.getUserMedia({ video: true, audio: false })
    .then(stream => {
      this.stream=stream
      this.cameraScreenTarget.srcObject = stream;
      this.cameraScreenTarget.play();
      const tracks = stream.getTracks();
    })
    .catch(function(err) {
      console.log("An error occurred: " + err);
    });
    this.cameraScreenTarget.setAttribute("height",400);
    this.cameraScreenTarget.setAttribute("width",400);
  };

  stopPhoto () {
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
  };

  noMoreButtonIfForm () {
    if (!this.formTarget.classList.contains("d-none")) {
      this.buttonValidateTarget.classList.add("d-none");
    };
  }

  validateButton(file) {
    if (file === undefined) {
      this.buttonValidateTarget.classList.add("d-none")
    } else {
      this.buttonValidateTarget.classList.remove("d-none")
    }
  };

  photo = async () => {
    const canvas = document.createElement('canvas');
    let width = 400;    // We will scale the photo width to this
    let height = 400;
    var context = canvas.getContext('2d');
    canvas.width = 400;
    canvas.height = 400;
    context.drawImage(this.cameraScreenTarget, 0, 0, width, height);
    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/png');
    });
    this.file = new File([data], 'medic_photo.jpg',{ type: 'image/jpeg' });
    this.cameraButtonTarget.classList.add("d-none");
    this.stopPhoto()
    this.validateButton(this.file);
  };

  validatePhoto(e) {
    e.preventDefault();
    console.log("Yeah you're in validate photo function");
    console.log(this.file)
    this.formTarget.classList.remove("d-none");
    this.noMoreButtonIfForm();
    // creating the FormData object to be sent in an HTTP request
    let formData = new FormData();   //appending the file key with the uploaded file in the FormData object
    formData.append("file", this.file);   // POST request for uploaded files

    console.log(this.formTarget)
    fetch(this.urlValue, {
        method: "POST",
        body: formData
    })
    .then(resp => resp.json())
    .then(data => {
      if (data.errors) {
        alert(data.errors)
      }
      else {
        console.log(data)
      }
    })
    console.log(data)
  };

  retakePhoto () {
    this.photoAgain()
    this.photo()
  }

  // submitForm () {
  //   window.location.href = this.urlValue;
  // }

};
