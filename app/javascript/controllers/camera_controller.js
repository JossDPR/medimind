import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "cameraButton"]
  static values = {
    url: String
  }

  connect() {
    console.log("Camera controller is in tha place!");
    // const video = this.cameraScreenTarget;

    navigator.mediaDevices.getUserMedia({ video: true, audio: false })
    .then(stream => {
      // video.srcObject = stream;
      // video.play();
      this.stream=stream
      this.cameraScreenTarget.srcObject = stream;
      this.cameraScreenTarget.play();
      const tracks = stream.getTracks();
      // tracks[0].stop;
    })
    .catch(function(err) {
      console.log("An error occurred: " + err);
    });

    // video.setAttribute("height",400);
    // video.setAttribute("width",400);
    this.cameraScreenTarget.setAttribute("height",400);
    this.cameraScreenTarget.setAttribute("width",400);

  };


  stopPhoto () {
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
  };

  photo = async () => {
    const canvas = document.createElement('canvas');
    let width = 400;    // We will scale the photo width to this
    let height = 400;
    // const video = this.cameraScreenTarget;
    // console.log(video)
    var context = canvas.getContext('2d');
    canvas.width = 400;
    canvas.height = 400;
    context.drawImage(this.cameraScreenTarget, 0, 0, width, height);

    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/png');
    });
    // console.log(data);
    this.file = new File([data], 'medic_photo.jpg',{ type: 'image/jpeg' });
    // console.log(file);
    // this.validatePhoto(file)

    this.cameraButtonTarget.classList.add("d-none");

    this.stopPhoto()
  };

  validatePhoto(e) {
    e.preventDefault();
    console.log("Yeah you're in validate photo function");
    // this.photo()
    // console.log(photo);
    // console.log(this.urlValue);
    console.log(this.file)


    //creating the FormData object to be sent in an HTTP request
    let formData = new FormData();   //appending the file key with the uploaded file in the FormData
    //object
    formData.append("file", this.file);   // POST request for uploaded files
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
   }

};
