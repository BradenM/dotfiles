# restore previous session
c.auto_save.session = True

# host blocking
c.content.host_blocking.enabled = True

# hide tab tooltips
c.tabs.tooltips = False

# Disable some websites requests, don't even ask for it
c.content.notifications = False
c.content.geolocation   = False

# minimize fingerprinting
c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/71.0.3578.80 Safari/537.36"
c.content.headers.accept_language = "en-US,en;q=0.5"
c.content.headers.do_not_track = False
