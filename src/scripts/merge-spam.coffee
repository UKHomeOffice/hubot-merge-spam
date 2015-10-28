# Description
#   A Hubot script that lists the pull requests
#
# Configuration:
#   HUBOT_MERGE_SPAM_ANNOUNCE_ROOMS
#   HUBOT_MERGE_SPAM_CRON
#   HUBOT_MERGE_SPAM_GITHUB_AUTH_USERNAME
#   HUBOT_MERGE_SPAM_GITHUB_AUTH_PASSWORD
#   HUBOT_MERGE_SPAM_GITLAB_HOST
#   HUBOT_MERGE_SPAM_GITLAB_API_TOKEN
#
# Commands:
#   hubot list pr - List pull requests from GitHub
#   hubot list mr - List merge requests from GitLab
#
# Author:
#   Billie Thompson <billie@purplebooth.co.uk>
#

Github = require('github-api');
async = require('async');
gitlab = null
GITHUB_PR_ORGANISATION = null
ANNOUNCE_ROOMS = []

PARALLELISATION_LIMIT = 10
CRONTAB = '0 * */3 * * *'

GITHUB_PR_ORGANISATION = process.env.HUBOT_MERGE_SPAM_GITHUB_ORGANISATION if process.env.HUBOT_MERGE_SPAM_GITHUB_ORGANISATION?
ANNOUNCE_ROOMS = process.env.HUBOT_MERGE_SPAM_ANNOUNCE_ROOMS.split(",") if process.env.HUBOT_MERGE_SPAM_ANNOUNCE_ROOMS?

if(ANNOUNCE_ROOMS.length < 1)
  console.log("merge spam announcements disabled");

CRONTAB = process.env.HUBOT_MERGE_SPAM_CRON if process.env.HUBOT_MERGE_SPAM_CRON?
github = null

if(process.env.HUBOT_MERGE_SPAM_GITHUB_AUTH_USERNAME? and process.env.HUBOT_MERGE_SPAM_GITHUB_AUTH_PASSWORD?)
  github = new Github({
    username: process.env.HUBOT_MERGE_SPAM_GITHUB_AUTH_USERNAME,
    password: process.env.HUBOT_MERGE_SPAM_GITHUB_AUTH_PASSWORD,
    auth: "basic"
  });
else
  github = new Github({})

gitLabMergeRequest = null
gitlab = null

if(process.env.HUBOT_MERGE_SPAM_GITLAB_HOST? and process.env.HUBOT_MERGE_SPAM_GITLAB_API_TOKEN?)
  gitlab = (require 'gitlab')
    url: process.env.HUBOT_MERGE_SPAM_GITLAB_HOST
    token: process.env.HUBOT_MERGE_SPAM_GITLAB_API_TOKEN

  gitLabMergeRequest = require('gitlab/lib/Models/ProjectMergeRequests')(gitlab.client);

getPullRequestsForOrganisation = (organsation, callback) ->
  github.getUser().orgRepos(
    organsation,
    (err, repos) ->
      if err
        console.error(err)
      else
        async.mapLimit(
          repos
          PARALLELISATION_LIMIT,
          (repoDetails, callback) ->
            repo = github.getRepo(repoDetails.owner.login, repoDetails.name)
            repo.listPulls(
              'open'
              (err, pullRequests) ->
                callback(err, pullRequests);
            )
          (err, results) ->
            console.log(err) if err

            callback(err, [].concat.apply([], results))
        )
  );

sayPullRequests = (say, pullRequests) ->
  message = pullRequests.length+" Pull Requests Waiting\n\u{2001}\n"

  for pullRequest in pullRequests
    message += "\u{2B50} #{pullRequest.base.repo.full_name}##{pullRequest.number} #{pullRequest.title}\n"
    message += "\u{1F517} #{pullRequest.html_url}\n"
    message += "\u{1F464} #{pullRequest.user.login}"
    message += " \u{1F50D} #{pullRequest.assignee.login}" if pullRequest.assignee
    message += "\n\u{2001}\n"

  if pullRequests
    console.log("Searching for Pull Requests: found "+ pullRequests.length)
    say(message)

getMergeRequestForOrganisation = (callback) ->
  gitlab.projects.all (projects) ->
    async.mapLimit(
      projects
      PARALLELISATION_LIMIT
      (project, callback) ->
        gitLabMergeRequest.list(project.id, null, (mergeRequests) ->
          decoratedMergeRequests = []

          for mergeRequest in mergeRequests
            mergeRequest.project = project
            decoratedMergeRequests.push(mergeRequest)

          callback(null, decoratedMergeRequests)
        )
      (err, results) ->
        console.log(err) if err

        async.filter(
          [].concat.apply([], results),
          (item, callback) ->
            callback(item.state == "opened")
          (results) ->
            callback(results)
        )
    )

sayMergeRequests = (say, mergeRequests) ->
  message = mergeRequests.length+" Merge Requests Waiting\n\u{2001}\n"

  for mergeRequest in mergeRequests
    message += "\u{2B50} #{mergeRequest.project.name_with_namespace}##{mergeRequest.iid} #{mergeRequest.title}\n"
    message += "\u{1F517} #{mergeRequest.project.web_url}/merge_requests/#{mergeRequest.iid}\n"
    message += "\u{1F464} #{mergeRequest.author.username}"
    message += " \u{1F50D} #{mergeRequest.assignee.username}" if mergeRequest.assignee
    message += "\n\u{2001}\n"

  if(mergeRequests)
    console.log("Searching for Merge Requests: found "+ mergeRequests.length)
    say(message)

listMrs = (say)->
  console.log("Listing Merge Requests")
  getMergeRequestForOrganisation(
    (mergeRequests) ->
      sayMergeRequests(say, mergeRequests)
  )

listPrs = (say)->
  console.log("Listing Pull Requests")
  getPullRequestsForOrganisation(
    GITHUB_PR_ORGANISATION
    (err, pullRequests) ->
      console.log(err) if err
      sayPullRequests(say, pullRequests) unless (err? and err != null)
  )

cron = require('cron');
cronJob = null;

module.exports = (robot) ->
  announce = ->
    say = (message) ->
      ANNOUNCE_ROOMS.forEach(
        (room) ->
          robot.messageRoom(room, message)
      )

    if(gitLabMergeRequest)
      listMrs(say)

    if(GITHUB_PR_ORGANISATION)
      listPrs(say)

  announce()

  cronJob = new cron.CronJob(
    CRONTAB
    -> announce
    null
    true
  )

  if(GITHUB_PR_ORGANISATION)
    robot.respond /l(:?ist)? (:?prs?|pull requests?)/i, (res) ->
      listPrs(
        (message)->
          res.reply(message)
      )

  if(gitLabMergeRequest)
    robot.respond /l(?:ist)? (:?mrs?|merge requests?)/i, (res) ->
      listMrs(
        (message)->
          res.reply(message)
      )


