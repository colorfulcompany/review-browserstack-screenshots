require 'octokit'

class PullRequest
  def initialize(repo, number, client: Octokit::Client.new(access_token: ENV['INPUT_REPO_TOKEN']))
    @repo = repo
    @number = number
    @client = client
  end

	#
	# @return [Boolean]
	#
  def keyword_exist?
    keyword_match
  end

	#
	# @param [String] commit_sha
	# @return [Boolean]
	#
  def already_taken?(commit_sha)
		prev_commit_sha == commit_sha
	end

	#
	# @param [String] body
	# @return [Object]
	#
	def add_comment(body)
		@client.add_comment(@repo, @number, body)
	end

	#
	# @param [String] commit
	# @return [Object]
	#
	def add_proof(commit_sha)
		if proof_match
			new_body = body.gsub(prev_commit_sha, commit_sha)
		else
			new_body = body.gsub(target_url, "#{target_url} \r\n📸 Took screenshots on: #{commit_sha}")
		end
		@client.update_issue(@repo, @number, body: new_body)
	end

	#
	# @return [String]
	#
	def body
		@body ||= @client.pull_request(@repo, @number)[:body]
	end

	#
	# @return [String]
	#
	def prev_commit_sha
		proof_match && proof_match[:commit_sha]
	end

	#
	# @return [String]
	#
  def target_url
    keyword_match && keyword_match[:url]
  end

	#
	# @return [Object]
	#
	def keyword_match
		body&.match(keyword_pattern)
	end

	#
	# @return [Object]
	#
  def proof_match
    body&.match(proof_pattern)
  end

	#
	# @return [Regexp]
	#
	def keyword_pattern
		/screenshot (?<url>[\w\/:%#\$&\?\(\)~\.=\+\-]+)/
	end

	#
	# @return [Regexp]
	#
  def proof_pattern
		/📸 Took screenshots on: (?<commit_sha>.{40})/
	end
end
