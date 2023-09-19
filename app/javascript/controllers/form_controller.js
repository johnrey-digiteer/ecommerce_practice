import { Controller } from "@hotwired/stimulus"
import debounce from "debounce"

// Connects to data-controller="form"
export default class extends Controller {
  connect() {
    console.log("Connected!")
  }
  initialize() {
    this.submit = debounce(this.submit.bind(this), 300)
  }
  submit() {
    this.element.requestSubmit();
  }
}
