# Leo's Arcade

This is a public website (https://leoarcade.com) built by a kid. Everything in `public/` is visible to anyone on the internet. Pushing to `main` publishes it within about a minute.

## Privacy check — required before every commit and push

Before running `git commit` or `git push`, review the changes (`git diff`, `git status`, new files) for personal information, and stop and ask Leo about anything you find. Look for:

- Last names (theirs or anyone else's), or full names of friends, classmates, or family
- Home address, street, neighborhood, or city/town
- School name, teacher names, grade, team or club names
- Phone numbers, email addresses, usernames on other sites/games
- Birthday or exact age
- Photos of people, or photos showing the house, street, school, or license plates
- Photo metadata: GPS location in images (the pre-commit hook checks this too)
- Passwords, API keys, or anything that looks like a secret

If you find something, explain kindly and simply why it's not a good idea on a public site, and suggest a safer alternative (first name or nickname, a made-up example, removing the detail). Don't commit until it's resolved. A first name and "Leo's Arcade" are fine.

A hook in `.claude/hooks/pii-check.sh` also scans `public/` automatically and blocks commits when it finds emails, phone numbers, addresses, or GPS data in images. If it flags something that is intentionally fake (e.g. a made-up email in a game), add the comment `pii-ok` on that line.

## Site basics

- Plain HTML/CSS/JS, no build step; served by a Cloudflare Worker from `public/`
- `public/index.html` is the landing page; games live in `public/games/<slug>/` and are listed in `public/games.js`
- See `README.md` for how to add a game
