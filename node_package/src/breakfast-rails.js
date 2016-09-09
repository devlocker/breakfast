const LiveReloader = require('./live-reload');
const StatusBar = require('./status-bar');
const ActionCable = require('actioncable');

const BreakfastRails = {
  init(options = {}) {
    options.cable = ActionCable.createConsumer(`ws://${options.host}:${options.port}/cable`);

    const liveReloader = new LiveReloader(options);
    const statusBar = new StatusBar(options);

    liveReloader.init();
    statusBar.init();
  }
};

module.exports = BreakfastRails;

