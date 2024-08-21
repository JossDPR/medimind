import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "cameraButton"]

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

    this.cameraButtonTarget.classList.add("d-none");
    // video.pause();
    // video.currentTime = 0;
    // this.cameraScreenTarget.pause();
    // this.cameraScreenTarget.currentTime=0;
    this.stream.getTracks().forEach(track => {
      track.stop();
    });

  };
}
