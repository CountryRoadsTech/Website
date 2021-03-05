// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
ActiveStorage.start() // Enable direct upload of form file attachments.

import "controllers" // Import all of StimulusJS's controllers.

import "../stylesheets/application.scss" // Import all of the site's styles.

require("trix") // Enables the Trix rich text editor.
require("@rails/actiontext") // Enables the rich text editor and viewing rich text content.

import 'bootstrap'

// Enables Bootstrap's tooltips.
document.addEventListener("turbo:load", () => {
    if (document.querySelector('[data-toggle="tooltip"]') != null) {
        document.querySelector('[data-toggle="tooltip"]').tooltip()
    }
})
