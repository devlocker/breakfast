const LiveReloader = require('./live-reload');

const BreakfastRails = {
  init(options = {}) {
    const liveReloader = new LiveReloader();
    liveReloader.init(options);
  }
};

module.exports = BreakfastRails;

