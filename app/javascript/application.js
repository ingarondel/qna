// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "activestorage"

require 'action_cable'
import "cocoon-js-vanilla";

import * as ActiveStorage from "@rails/activestorage"
ActiveStorage.start()

var App = App || {};
App.cable = ActionCable.createConsumer();

