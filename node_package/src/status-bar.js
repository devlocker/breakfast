const LOCAL_STORAGE_KEY = 'breakfast-last-log';
const STATUS_CHANNEL = 'Breakfast::StatusChannel';

class StatusBar {
  constructor(options = {}) {
    this.options = options;
  }

  init() {
    ['DOMContentLoaded', 'turbolinks:load']
      .forEach(event => document.addEventListener(event, () => {
        const lastLog = JSON.parse(localStorage.getItem(LOCAL_STORAGE_KEY)) || {};
        this.drawStatusBar(lastLog);

        this.options.cable.subscriptions.create(STATUS_CHANNEL, {
          received: (statusData) => {
            localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(statusData));
            this.drawStatusBar(statusData);
          }
        });
      })
    );
  }

  drawStatusBar(statusData = {}) {
    const statusBar = document.getElementById('breakfast-status-bar');

    if (statusBar) {
      document.body.removeChild(statusBar);
    }

    const colors = {
      'success': '#539417',
      'error': '#a93131'
    };

    document.body.innerHTML += `
      <div id="breakfast-status-bar" style="
        font-family: monospace;
        font-size: 13px;
        position:fixed;
        min-width:300px;
        padding: 6px;
        background: ${colors[statusData.status]};
        color: #fff;
        white-space: pre-wrap;
        ${this.options.statusBarLocation}: 0;"
      >Breakfast: ${ statusData.message }</div>
    `;
  }
}

module.exports = StatusBar;
