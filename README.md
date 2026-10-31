# Leo's Arcade

Free browser games designed by Leo, served at **https://leoarcade.com**.
Everything is static: plain HTML, CSS and JavaScript, deployed as a Cloudflare Worker with static assets.

## Layout

```
public/
  index.html                  landing page (newest game + all games)
  games.js                    the list of games the landing page shows
  404.html                    "not found" page
  favicon.svg
  _headers                    cache rules
  vendor/three-r128.min.js    three.js, used by the 3D games
  games/
    rune-king-vs-dead/
      index.html              the game
      cover.jpg               16:9 card image (1600x900)
    floofiness/
      index.html              3D cat runner (open with ?autoplay for a demo, ?cover renders the cover scene)
      cover.jpg
    rune-king-unstoppable-god/
      index.html              the game (title screen has the arcade link)
      cover.jpg               16:9 card image (1600x900)
wrangler.jsonc                Cloudflare Worker config (serves ./public)
```

## Add a new game

1. Make a folder `public/games/<slug>/` with the game's `index.html` and a 16:9 `cover.jpg`.
2. Add an entry to `public/games.js`:
   ```js
   {
     slug: "my-new-game",
     title: "My New Game",
     href: "/games/my-new-game/",
     cover: "/games/my-new-game/cover.jpg",
     blurb: "One or two sentences about the game.",
     tags: ["3D", "Math"],
     added: "2026-11-01",   // newest date becomes "Newest game" on the landing page
     accent: "#f5be2c"
   }
   ```
3. Commit and push to `main`. Cloudflare rebuilds and deploys automatically.

Games should link back to the arcade (`<a href="/">← Leo's Arcade</a>`) and use root-relative paths
(for example `/vendor/three-r128.min.js`) so they work at `leoarcade.com/games/<slug>/`.

## Run it locally

Any static server works, for example:

```
npx wrangler dev        # serves ./public like Cloudflare does
# or
python3 -m http.server -d public 8000
```

## Deploy

Cloudflare Workers Builds is connected to this repo: every push to `main` runs `npx wrangler deploy`,
which uploads `./public`. Manual deploy from a laptop: `npx wrangler deploy`.
