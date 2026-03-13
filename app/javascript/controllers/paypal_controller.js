import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    clientId: String,
    currency: { type: String, default: "USD" }
  }

  static targets = ["buttons", "status"]

  connect() {
    if (this.element.dataset.paypalRendered === "true") return

    if (!this.clientIdValue) {
      this.showError("Missing PAYPAL_CLIENT_ID")
      return
    }

    this.waitForSdk()
      .then(() => this.renderButtons())
      .catch((error) => this.showError(error.message))
  }

  waitForSdk() {
    if (window.paypal) return Promise.resolve()

    return new Promise((resolve, reject) => {
      let attempts = 0
      const tick = () => {
        if (window.paypal) {
          resolve()
          return
        }

        attempts += 1
        if (attempts >= 50) {
          reject(new Error("PayPal SDK failed to load"))
          return
        }

        setTimeout(tick, 100)
      }

      tick()
    })
  }

  renderButtons() {
    if (!window.paypal) {
      this.showError("PayPal SDK unavailable")
      return
    }

    this.element.dataset.paypalRendered = "true"

    window.paypal
      .Buttons({
        createOrder: () => this.createOrder(),
        onApprove: (data) => this.captureOrder(data),
        onError: (err) => this.showError(err?.message || "PayPal error")
      })
      .render(this.buttonsTarget)
  }

  createOrder() {
    return this.requestJson("/paypal/orders", {}).then((data) => {
      if (!data.id) {
        throw new Error(data.error || "Could not create order")
      }
      return data.id
    })
  }

  captureOrder(data) {
    return this.requestJson(`/paypal/orders/${data.orderID}/capture`, {}).then((payload) => {
      if (payload.status !== "ok") {
        throw new Error(payload.error || "Payment failed")
      }

      this.showSuccess("Payment confirmed. Thank you!")
    })
  }

  showError(message) {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = message
    this.statusTarget.classList.add("paypal-status-error")
    this.statusTarget.classList.remove("paypal-status-success")
  }

  showSuccess(message) {
    if (!this.hasStatusTarget) return
    this.statusTarget.textContent = message
    this.statusTarget.classList.add("paypal-status-success")
    this.statusTarget.classList.remove("paypal-status-error")
  }

  requestJson(url, payload) {
    return fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Accept: "application/json"
      },
      body: JSON.stringify(payload)
    }).then(async (response) => {
      const contentType = response.headers.get("content-type") || ""
      if (!contentType.includes("application/json")) {
        throw new Error("Please sign in to purchase.")
      }

      const data = await response.json()
      if (!response.ok) {
        throw new Error(data.error || "Request failed")
      }

      return data
    })
  }
}
