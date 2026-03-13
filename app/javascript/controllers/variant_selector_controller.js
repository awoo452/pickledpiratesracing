import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["select", "price", "submit"]

  connect() {
    this.update()
  }

  update() {
    if (!this.hasSelectTarget) return

    const option = this.selectTarget.options[this.selectTarget.selectedIndex]
    const disabled = !option || option.disabled || !option.value

    if (this.hasSubmitTarget) {
      this.submitTarget.disabled = disabled
    }

    if (this.hasPriceTarget) {
      const price = option?.dataset?.price
      this.priceTarget.textContent = price ? Number.parseFloat(price).toFixed(2) : "—"
    }
  }
}
