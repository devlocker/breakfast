const RELOAD_CHANNEL = 'Breakfast::LiveReloadChannel';

class LiveReloader {
  constructor(settings) {
    this.settings = settings;
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
        this.reloadTurbolinks();
        break;
      case 'wiselinks':
        this.reloadWiselinks();
        break;
      case 'page':
        window.top.location.reload();
        break;
      case 'off':
        break;
    }
  }

  rubyReload(strategy) {
    switch (strategy) {
      case 'turbolinks':
        this.reloadTurbolinks();
        break;
      case 'wiselinks':
        this.reloadWiselinks();
        break;
      case 'page':
        window.top.location.reload();
        break;
      case 'off':
        break;
    }
  }

  reloadTurbolinks() {
    const location = window.top.location;

    if (typeof Turbolinks !== 'undefined' && !this.onErrorPage()) {
      Turbolinks.visit(location);
    } else {
      location.reload();
    }
  }

  reloadWiselinks() {
    if (typeof wiselinks !== 'undefined' && !this.onErrorPage()) {
      wiselinks.reload();
    } else {
      window.top.location.reload();
    }
  }
  // If user is on an error page and they fix the error and re-render using
  // turbolinks than the CSS from the Rails error page will hang around. Will
  // initiate a full refresh to get rid of it.
  onErrorPage() {
    return (document.title.indexOf('Exception caught') !== -1);
  }

  init() {
    const reloaders = {
      js: this.jsReload.bind(this),
      css: this.cssReload.bind(this),
      html: this.htmlReload.bind(this),
      slim: this.htmlReload.bind(this),
      haml: this.htmlReload.bind(this),
      rb: this.rubyReload.bind(this)
    };

    document.addEventListener('DOMContentLoaded', () => {
      this.settings.cable.subscriptions.create(RELOAD_CHANNEL, {
        received: (data) => {
          const reloader = reloaders[data.extension];
          reloader(this.settings.strategies[data.extension]);
        }
      });
    });
  }
}

module.exports = LiveReloader;
