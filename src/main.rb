#!/usr/bin/env ruby

require_relative './configuration'
require_relative './lib/comment'
require_relative './lib/pull_request'
require_relative './lib/camera'

config = Configuration.new

pr = PullRequest.new(ENV['GITHUB_REPOSITORY'], ENV['INPUT_PR_NUMBER'])

return if !pr.keyword_exist?
return if pr.already_taken?(ENV['INPUT_COMMIT_SHA'])

preview_url, screenshots = Camera.new.take(pr.target_url, config.browsers, config.local?, config.port)

comment = Comment.new(ENV['INPUT_COMMIT_SHA'], pr.target_url, preview_url, screenshots, config.should_show_table)
pr.add_comment(comment.body)

pr.add_proof(ENV['INPUT_COMMIT_SHA'])
