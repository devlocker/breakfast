---
layout: default
---

# Asset Digests (or Asset Fingerprints)

Asset Digests are a feature in Breakfast which add a unique string (digest,
fingerprint) to every asset filename. 

The rationale for doing this in a production environment is that you can
take advantage of [HTTP
Caching](https://developers.google.com/web/fundamentals/performance/optimizing-content-efficiency/http-caching).

If assets did not have these digests added you could not reliably use
Cache-Control headers.

> For example, suppose you've told your visitors to cache a CSS
> stylesheet for up to 24 hours (max-age=86400), but your designer has
> just committed an update that you'd like to make available to all
> users. How do you notify all the visitors who have what is now a
> "stale" cached copy of your CSS to update their caches? You can't, at
> least not without changing the URL of the resource.

By implementing digests we can set Cache Control headers far out
into the future without worrying about serving stale assets. If the
content of the file changes, so will the digest. If you re-deploy
with the same assets, the Digest will stay the same, keeping the
cache intact.
