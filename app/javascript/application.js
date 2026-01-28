// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

const setupHerokuUploadGuard = () => {
  document.querySelectorAll("form[data-heroku-upload]").forEach((form) => {
    const herokuHost = form.dataset.herokuHost
    const herokuUrl = form.dataset.herokuUrl

    if (!herokuHost || !herokuUrl || window.location.host === herokuHost) {
      return
    }

    const redirectToHeroku = (event) => {
      event.preventDefault()
      window.location.href = herokuUrl
    }

    form.addEventListener("submit", redirectToHeroku)

    form.querySelectorAll('input[type="file"][data-heroku-guard="true"]').forEach((input) => {
      input.addEventListener("click", redirectToHeroku)
    })
  })
}

document.addEventListener("turbo:load", setupHerokuUploadGuard)
