const LiveReloader = require('./live-reload');
const StatusBar = require('./status-bar');
const Settings = require('./settings');

const BreakfastRails = {
  init(options = {}) {
    window.Breakfast = (window.Breakfast || {});

    const settings = new Settings(options);
    const liveReloader = new LiveReloader(settings);
    const statusBar = new StatusBar(settings);

    liveReloader.init();
    statusBar.init();
  }
};

module.exports = BreakfastRails;

