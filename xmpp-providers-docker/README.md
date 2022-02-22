This is a nanoservice that fetches the latest JSON files from the
[xmpp-providers project](https://invent.kde.org/melvo/xmpp-providers) so we
can serve them at data.xmpp.net.

I considered proxying directly to the upstream via nginx, with a long cache TTL,
but nginx has the limitation that it does not re-resolve DNS records when making
requests to upstream servers.
