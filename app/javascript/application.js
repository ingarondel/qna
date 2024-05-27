// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "activestorage"

import "cocoon-js-vanilla";

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

