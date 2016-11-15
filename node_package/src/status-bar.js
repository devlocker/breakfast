const STATUS_CHANNEL = 'Breakfast::StatusChannel';

class StatusBar {
  constructor(settings = {}) {
    this.settings = settings;

    this.settings.cable.subscriptions.create(STATUS_CHANNEL, {
      connected: () => {
        this.write(this.settings.log.message, this.settings.log.status);
      },
      received: (log) => {
        if (this.settings.strategies[log.extension] !== 'off') {
          this.settings.updateLog(log);
          this.write(log.message, log.status);
        }
      },
      disconnected: () => {
        this.write('Disconnected from server...', 'error');
      }
    });
  }

  init() {
    let eventName;

    if (typeof Turbolinks !== 'undefined') {
      eventName = 'turbolinks:load';
    } else {
      eventName = 'DOMContentLoaded';
    }

    document.addEventListener(eventName, () => {
      this.render();
      this.write(this.settings.log.message, this.settings.log.status);
    });

    window.Breakfast.StatusBar = this;
  }

  write(message, status) {
    const log = document.getElementById('breakfast-message-log');
    if (log) {
      log.innerHTML = message;
      log.className = `breakfast-message-log-${ status }`;
    }
  }

  handleClick(option) {
    this.settings.updateStrategies(option);
    const reloaders = document.getElementById('breakfast-reloaders');
    reloaders.innerHTML = this.renderReloaders();
  }

  render() {
    const statusBar = document.getElementById('breakfast-status-bar');

    if (statusBar) { document.body.removeChild(statusBar); }

    const sb = document.createElement('DIV');
    sb.setAttribute('class', 'breakfast-status-bar');
    sb.setAttribute('id', 'breakfast-status-bar');

    sb.innerHTML = `
      ${ this.stylesheet() }
      <div id="breakfast-reloaders" class="breakfast-reloaders">
        ${ this.renderReloaders() }
      </div>
      <div id="breakfast-message-log">
      </div>
   `;

    document.body.appendChild(sb);
  }

  renderReloaders() {
    return (`
      <div class="breakfast-reloader">
        <span>js: </span><span class="breakfast-type">${ this.settings.strategies.js }</span>
        <div class="breakfast-menu">
          ${ this.renderLink('js', 'page', 'Page Reload') }
          ${ this.renderLink('js', 'off', 'Off') }
        </div>
      </div>

      <div class="breakfast-reloader">
        <span>css: </span><span class="breakfast-type">${ this.settings.strategies.css }</span>
        <div class="breakfast-menu">
          ${ this.renderLink('css', 'page', 'Page Reload') }
          ${ this.renderLink('css', 'hot', 'Hot Reload') }
          ${ this.renderLink('css', 'off', 'Off') }
        </div>
      </div>
      <div class="breakfast-reloader">
        <span>html: </span><span class="breakfast-type">${ this.settings.strategies.html }</span>
        <div class="breakfast-menu">
          ${ this.renderLink('html', 'page', 'Page Reload') }
          ${ this.renderLink('html', 'turbolinks', 'Turbolinks Reload') }
          ${ this.renderLink('html', 'off', 'Off') }
        </div>
      </div>

      <div class="breakfast-reloader">
        <span>ruby: </span><span class="breakfast-type">${ this.settings.strategies.rb }</span>
        <div class="breakfast-menu">
          ${ this.renderLink('rb', 'page', 'Page Reload') }
          ${ this.renderLink('rb', 'turbolinks', 'Turbolinks Reload') }
          ${ this.renderLink('rb', 'off', 'Off') }
        </div>
      </div>
    `);
  }

  renderLink(type, strategy, text) {
    const active = this.settings.strategies[type] === strategy;

    return (`
      <a
        class="breakfast-menu-option ${ active ? 'breakfast-active' : '' }"
        onclick="Breakfast.StatusBar.handleClick({'${ type }': '${ strategy }'}); return false;"
        href="#"
      >
        <div class="breakfast-toggle"></div><div>${ text }</div>
      </a>
    `);
  }

  stylesheet() {
    return (`
      <style>
        .breakfast-status-bar {
          align-items: center;
          background-color: #1f1f1f;
          ${this.settings.statusBarLocation}: 0;
          color: #999;
          font-family: monospace;
          font-size: 12px;
          display: flex;
          height: 30px;
          position: fixed;
          width: 100%;
        }

        .breakfast-status-bar .breakfast-reloaders {
          align-items: center;
          display: flex;
        }

        .breakfast-status-bar .breakfast-reloader {
          border-left: 1px solid #444;
          padding: 4px 8px;
          position: relative;
        }

        .breakfast-status-bar .breakfast-reloader:hover {
          cursor: pointer;
        }

        .breakfast-status-bar .breakfast-reloader:hover .breakfast-menu {
          display: block;
        }

        .breakfast-status-bar .breakfast-type {
          color: #eee;
        }

        .breakfast-status-bar .breakfast-menu {
          background-color: #1f1f1f;
          border-radius: 2px;
          ${this.settings.statusBarLocation}: 22px;
          display: none;
          left: 0;
          position: absolute;
          width: 225px;
        }

        .breakfast-status-bar .breakfast-menu-option {
          align-items: center;
          border-bottom: 1px solid #000;
          border-top: 1px solid #333;
          color: #999;
          display: flex;
          padding: 6px 15px;
          z-index: 1000;
        }

        .breakfast-status-bar .breakfast-menu-option:hover {
          background-color: #333;
          text-decoration: none;
        }

        .breakfast-status-bar .breakfast-active {
          color: #eee;
        }

        .breakfast-status-bar .breakfast-active .breakfast-toggle {
          background-color: #539417;
        }

        .breakfast-status-bar .breakfast-toggle {
          background-color: #000;
          border-radius: 50%;
          height: 8px;
          margin-right: 8px;
          width: 8px;
        }

        .breakfast-status-bar .breakfast-message-log-success {
          align-items: center;
          background-color: #539417;
          color: #fff;
          display: flex;
          flex-grow: 1;
          height: 30px;
          padding: 0 8px;
        }

        .breakfast-status-bar .breakfast-message-log-error {
          align-self: ${ this.settings.statusBarLocation === 'bottom' ? 'flex-end' : 'flex-start' };
          background-color: #a93131;
          color: #fff;
          flex-grow: 1;
          min-height: 30px;
          padding: 5px 8px;
          white-space: pre-wrap;
        }
      </style>
    `);
  }
}

module.exports = StatusBar;
