import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "cameraButton"]

  connect() {
    console.log("Camera controller is in tha place!");
    const video = this.cameraScreenTarget;

    navigator.mediaDevices.getUserMedia({ video: true, audio: false })
    .then(function(stream) {
      video.srcObject = stream;
      video.play();
    })
    .catch(function(err) {
      console.log("An error occurred: " + err);
    });

    video.setAttribute("height",400);
    video.setAttribute("width",400);

    };

  photo = async () => {
    const canvas = document.createElement('canvas');
    let width = 400;    // We will scale the photo width to this
    let height = 400;
    const video = this.cameraScreenTarget;
    // console.log(video)
    var context = canvas.getContext('2d');
    canvas.width = 400;
    canvas.height = 400;
    context.drawImage(video, 0, 0, width, height);

    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/png');
    });

    this.cameraButtonTarget.innerText = "✅";
    video.pause();
    video.currentTime = 0;


  };
}
