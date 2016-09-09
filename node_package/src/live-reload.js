class LiveReloader {
  constructor(options = {}) {
    this.options = options;
  }

  buildFreshUrl(url) {
    const date = Math.round(Date.now() / 1000).toString();
    url = url.replace(/(\&|\\?)version=\d*/, '');

    return (`${url}${(url.indexOf('?') >= 0 ? '&' : '?')}version=${date}`);
  }

  cssReload(strategy) {
    switch (strategy) {
      case 'hot':
        const reloadableLinkElements = window.top.document.querySelectorAll(
          'link[rel=stylesheet]:not([data-no-reload]):not([data-pending-removal])'
        );

        [].slice
          .call(reloadableLinkElements)
          .filter(link => link.href)
          .forEach(link => link.href = this.buildFreshUrl(link.href));

        // Repaint
        const browser = navigator.userAgent.toLowerCase();

        if (browser.indexOf('chrome') > -1) {
          setTimeout(() => { document.body.offsetHeight; }, 25);
        }
        break;
      case 'page':
        window.top.location.reload();
        break;
      case 'off':
        break;
    }
  }

  jsReload(strategy) {
    switch (strategy) {
      case 'page':
        window.top.location.reload();
        break;
      case 'off':
        break;
    }
  }

  htmlReload(strategy) {
    switch (strategy) {
      case 'turbolinks':
        const location = window.top.location;

        if (typeof Turbolinks !== 'undefined') {
          Turbolinks.visit(location);
        } else {
          location.reload();
        }
        break;
      case 'page':
        window.top.location.reload();
        break;
      case 'off':
        break;
    }
  }

  init() {
    const reloaders = {
      js: this.jsReload.bind(this),
      css: this.cssReload.bind(this),
      html: this.htmlReload.bind(this)
    };

    document.addEventListener('DOMContentLoaded', () => {
      const reloadChannel = 'Breakfast::LiveReloadChannel';

      this.options.cable.subscriptions.create(reloadChannel, {
        received: (data) => {
          const reloader = reloaders[data.extension];
          reloader(this.options.reloadStrategies[data.extension]);
        }
      });
    });
  }
}

module.exports = LiveReloader;
