# GH Review 

[![Build Status](https://travis-ci.org/UKHomeOffice/hubot-merge-spam.svg?branch=master)](https://travis-ci.org/UKHomeOffice/hubot-merge-spam) [![npm version](https://badge.fury.io/js/hubot-merge-spam.svg)](https://badge.fury.io/js/hubot-merge-spam)

Periodically announce to the channel what merge requests are available. Also print them on demand. Supports both GitLab's Merge Requests and GitHubs Pull Requests.

## Usage

This is a plugin to Hubot

```
5:34:08 PM <•purplebooth> dec4rd: list mr
5:34:09 PM <•dec4rd> @purplebooth: Listing Merge Requests
5:34:09 PM <•dec4rd>  
5:34:09 PM <•dec4rd> ⭐ API-Factory / data-assurance-dataimport#3 Added standard format
5:34:09 PM <•dec4rd> ⭐🔗 https://gitlab.digital.homeoffice.gov.uk/API-Factory/data-assurance-dataimport/merge_requests/3 
5:34:09 PM <•dec4rd> 👤 purplebooth
5:34:09 PM <•dec4rd>  
5:34:09 PM <•dec4rd> ⭐ API-Factory / data-assurance-api#9 This should cause a test to fail
5:34:09 PM <•dec4rd> ⭐🔗 https://gitlab.digital.homeoffice.gov.uk/API-Factory/data-assurance-api/merge_requests/9 
5:34:09 PM <•dec4rd> 👤 mikeyhu
5:34:09 PM <•dec4rd>  
5:34:09 PM <•dec4rd> ⭐ API-Factory / data-assurance-api#7 Standardise on coding style
5:34:09 PM <•dec4rd> ⭐🔗 https://gitlab.digital.homeoffice.gov.uk/API-Factory/data-assurance-api/merge_requests/7 
5:34:09 PM <•dec4rd> 👤 purplebooth
5:34:09 PM <•dec4rd>  
```

```
9:23:33 AM <•purplebooth> dec4rd: list pr
9:23:35 AM <•dec4rd> @purplebooth: Listing Pull Requests
9:23:35 AM <•dec4rd>  
9:23:35 AM <•dec4rd> ⭐ UKHomeOffice/passports-form-wizard#31 Support for multiple translators
9:23:35 AM <•dec4rd> ⭐🔗 https://github.com/UKHomeOffice/passports-form-wizard/pull/31 
9:23:35 AM <•dec4rd> 👤 easternbloc 🔍 gavboulton
9:23:35 AM <•dec4rd>  
9:23:35 AM <•dec4rd> ⭐ UKHomeOffice/vaultconf#13 Added support for configuring secrets in vault
9:23:35 AM <•dec4rd> ⭐🔗 https://github.com/UKHomeOffice/vaultconf/pull/13 
9:23:35 AM <•dec4rd> 👤 timgent
9:23:35 AM <•dec4rd>  
9:23:35 AM <•dec4rd> ⭐ UKHomeOffice/RTM#4 Add a local dev environment based on docker-compose
9:23:35 AM <•dec4rd> ⭐🔗 https://github.com/UKHomeOffice/RTM/pull/4 
9:23:35 AM <•dec4rd> 👤 daniel-ac-martin
9:23:35 AM <•dec4rd>  
9:23:35 AM <•dec4rd> ⭐ UKHomeOffice/removals_dashboard#11 BM-264 unit tests
9:23:35 AM <•dec4rd> ⭐🔗 https://github.com/UKHomeOffice/removals_dashboard/pull/11 
9:23:35 AM <•dec4rd> 👤 fulljames 🔍 chrisns
9:23:35 AM <•dec4rd>  
```

```shell
$ docker run -i quay.io/purplebooth/gh-review:$VERSION

  Usage: gh-review [options] <organisationName>

  Review the status of an organisations public github account and score it based on documents present (like READMEs)

  Options:

    -h, --help                 output usage information
    -V, --version              output the version number
    -u, --username <username>  GitHub Username (Optional)
    -p, --password <password>  GitHub Password (Optional)
    -o, --oauth <oauth>        OAuth2 token to authenticate with (Optional)
    -i, --createIssues         Create issues for the problems identified, requires authentication (Optional)
    -s, --publicOnly           Public only, even if authenticated (Optional)
```

## Installing

To add this plugin to hubot run 

```
npm i --save hubot-merge-spam
```

And add `hubot-merge-spam` to `external-scripts.json` in your hubot

## Environment Variables

* `HUBOT_MERGE_SPAM_ANNOUNCE_ROOMS` Rooms to periodically announce the state of the PRs and MRs into. Make this empty to not announce
* `HUBOT_MERGE_SPAM_CRON` [Standard CRON](http://linuxconfig.org/linux-cron-guide) for when it should announce. Defaults to every 3 hours.
* `HUBOT_MERGE_SPAM_GITHUB_ORGANISATION` GitHub Organisation to get the Pull Requests from. If this is blank it'll disable the GitHub functionality.
* `HUBOT_MERGE_SPAM_GITHUB_AUTH_USERNAME` GitHub Username. If this or the auth token are missing it'll try to do the requests without authentication, but it'll probably hit rate limiting.
* `HUBOT_MERGE_SPAM_GITHUB_AUTH_PASSWORD` GitHub password (generate one). 
* `HUBOT_MERGE_SPAM_GITLAB_HOST` GitLab URL. If token or this are missing it'll disable the GitLab aspects. 
* `HUBOT_MERGE_SPAM_GITLAB_API_TOKEN` GitLab API Token

## Contributing

Please read [CONTRIBUTING.md](CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/UKHomeOffice/hubot-merge-spam/tags). 

## Authors

See the list of [contributors](https://github.com/UKHomeOffice/hubot-merge-spam/contributors) who participated in this project.

## License

This project is licensed under the GPL v2 License - see the [LICENSE.md](LICENSE.md) file for details
