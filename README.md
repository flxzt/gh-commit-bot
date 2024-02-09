# gh-commit-bot

Steps:

- Create an access token and set the origin URL to this schema to be able to push automatically:
    `https://<username>:<access-token>@<domain>/<owner>/<reponame>.git`
- Enable user service lingering: `loginctl enable-linger "$USER"`
- Run `./deploy.sh`

New commits should now be created daily.
