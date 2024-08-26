import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="camera"
export default class extends Controller {
  static targets= ["cameraScreen", "cameraButton", "form", "buttonValidate", "url"]
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
    onpopstate = (event) => {
      this.stopPhoto()
    }
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

    onpopstate = (event) => {
      this.stopPhoto()
    }
  };

  stopPhoto () {
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
  };

  stopPhotoAndBack (event) {
    const url = event.currentTarget.dataset.url;
    this.stream.getTracks().forEach(track => {
      track.stop();
    });
    window.location.href = url;
  };

  noMoreButtonIfForm () {
    if (!this.formTarget.classList.contains("d-none")) {
      this.buttonValidateTarget.classList.add("d-none");
    };
  };

  validateButton(file) {
    if (file === undefined) {
      this.buttonValidateTarget.classList.add("d-none")
    } else {
      this.buttonValidateTarget.classList.remove("d-none")
    }
  };

  photo = async () => {
    const canvas = document.createElement('canvas');
    const width = 400;
    const height = 600;
    var context = canvas.getContext('2d');
    canvas.width = width;
    canvas.height = height;
    context.drawImage(this.cameraScreenTarget, 0, 0, width, height);
    let data = await new Promise((resolve) => {
      canvas.toBlob(resolve, 'image/jpeg');
    });
    this.file = new File([data], 'medic_photo.jpg',{ type: 'image/jpeg' });
    this.cameraButtonTarget.classList.add("d-none");
    const imgElement = document.createElement('img');

    // Convert the blob to a URL and set it as the src of the img element
    const imageUrl = URL.createObjectURL(data);
    imgElement.src = imageUrl;
    // Optionally, you can set attributes like width and height for the img element
    imgElement.width = width;
    imgElement.height = height;
    // Replace the canvas (or any other element, like video) with the img element
    this.cameraScreenTarget.parentNode.replaceChild(imgElement, this.cameraScreenTarget);

    this.stopPhoto()
    this.validateButton(this.file);
  };

  validatePhoto(event) {
    event.preventDefault();
    // console.log("Yeah you're in validate photo function");
    // console.log(this.file)
    this.formTarget.classList.remove("d-none");
    this.noMoreButtonIfForm();
  };

  retakePhoto () {
    this.photoAgain()
    this.photo()
  }

  submitForm(event) {
    event.preventDefault();
    // creating the FormData object to be sent in an HTTP request
    let formData = new FormData(this.formTarget);
    // formData.append(this.formTarget);  //appending the file key with the uploaded file in the FormData object
    formData.append("file", this.file);   // POST request for uploaded files
    console.log(formData)
    // console.log(this.formTarget)
    console.log(document.getElementsByName('csrf-token'))
    console.log(this.file)
    const token = document.getElementsByName('csrf-token')[0].content
    fetch(this.urlValue, {
        method: "POST",
        // definir un header dans lequel mettre le  csrf token pour rails:
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
        console.log(data)
      }
    })
  }

};
