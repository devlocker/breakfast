const LOCAL_STORAGE_KEY = 'breakfast-rails-settings';
const ActionCable = require('actioncable');

class Settings {
  constructor(options = {}) {
    this.options = options;
    this.host = options.host;
    this.port = options.port;
    this.strategies = this.determineStrategies();
    this.statusBarLocation = options.statusBarLocation;
    this.cable = ActionCable.createConsumer(`ws://${this.host}:${this.port}/cable`);
    this.log = (this.storedSettings().log || {});

    this.save();
  }

  save() {
    localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify({
      host: this.host,
      port: this.port,
      strategies: this.strategies,
      log: this.log
    }));
  }

  determineStrategies() {
    const defaults = this.options.strategies || {};
    const existing = this.storedSettings().strategies || {};

    return (Object.assign(defaults, existing));
  }

  updateStrategies(strategy) {
    this.strategies = Object.assign(this.strategies, strategy);
    this.save();
  }

  updateLog(log) {
    this.log = log;
    this.save();
  }

  storedSettings() {
    return (JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY)) || {});
  }

  turbolinksEnabled() {
    return typeof Turbolinks !== 'undefined';
  }

  wiselinksEnabled() {
    return typeof Wiselinks !== 'undefined';
  }
}

module.exports = Settings;
