import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dynamic-select"
export default class extends Controller {
  static targets = ["select", "choice", "long"]

  connect() {
    this.selected()
  }

selected() {
  this.hideFields();

  const targetElements = {
    single_choice: this.choiceTarget,
    multiple_choice: this.choiceTarget,
    long_answer: this.longTarget,
  };

  const selectedElement = targetElements[this.selectTarget.value];

  selectedElement.classList.remove('hidden');
}

  hideFields() {
    [this.choiceTarget, this.longTarget].forEach(target => target.classList.add('hidden'));
  }
}
