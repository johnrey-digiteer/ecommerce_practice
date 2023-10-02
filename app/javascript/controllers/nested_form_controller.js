import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="nested-form"
export default class extends Controller {
  static targets = ["add_item", "template"]

  add_association(event) {
    event.preventDefault();
    const timestamp = new Date().getTime();
    const content = this.templateTarget.innerHTML.replace(/TEMPLATE_RECORD/g, timestamp);
    this.add_itemTarget.insertAdjacentHTML('beforebegin', content);
  }

  remove_association(event) {
    event.preventDefault();
    const item = event.target.closest(".nested-fields");
    const destroyInput = item.querySelector("input[name*='_destroy']");
    destroyInput.value = 1;
    item.style.display = 'none';
  }
}
