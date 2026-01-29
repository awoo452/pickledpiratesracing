// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const canPersistVideoPreference = () => {
  try {
    const testKey = "ppr_video_pref_test"
    window.localStorage.setItem(testKey, "1")
    window.localStorage.removeItem(testKey)
    return true
  } catch (_error) {
    return false
  }
}

const shouldAutoloadYoutube = () => {
  const cookiesEnabled = navigator.cookieEnabled
  const storageOk = canPersistVideoPreference()

  return cookiesEnabled && storageOk
}

const loadYoutubeIframe = (placeholder, autoplay) => {
  const embedUrl = placeholder.dataset.embedUrl
  if (!embedUrl) return

  const iframe = document.createElement("iframe")
  iframe.className = "youtube-video"

  if (autoplay) {
    iframe.src = embedUrl.includes("?") ? `${embedUrl}&autoplay=1` : `${embedUrl}?autoplay=1`
  } else {
    iframe.src = embedUrl
  }

  iframe.allow =
    "accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share"
  iframe.allowFullscreen = true
  iframe.setAttribute("frameborder", "0")

  placeholder.replaceWith(iframe)
}

const setupYoutubePlaceholders = () => {
  document.querySelectorAll(".youtube-placeholder").forEach((placeholder) => {
    if (shouldAutoloadYoutube()) {
      loadYoutubeIframe(placeholder, false)
      return
    }

    const button = placeholder.querySelector("button")
    if (!button) return

    button.addEventListener("click", (event) => {
      event.preventDefault()

      if (placeholder.dataset.loaded === "true") return
      placeholder.dataset.loaded = "true"

      loadYoutubeIframe(placeholder, true)
    })
  })
}

document.addEventListener("turbo:load", setupYoutubePlaceholders)
