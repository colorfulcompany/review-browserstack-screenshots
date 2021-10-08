require 'erb'

class Comment
  def initialize(
    commit_sha,
    target_url,
    preview_url,
    screenshots,
    should_show_table
  )
    @commit_sha = commit_sha
    @target_url = target_url
    @preview_url = preview_url
    @screenshots = screenshots
    @should_show_table = should_show_table
  end

  #
  # @return [ERB]
  #
  def body
		ERB.new(template, nil, 2).result_with_hash(
      preview_url: @preview_url,
      target_url: @target_url,
      screenshots: @screenshots,
      commit_sha: @commit_sha,
      should_show_table: @should_show_table
    )
	end

  #
  # @return [String]
  #
  def template
    File.read(File.join(__dir__	, '../templates/comment.erb'))
  end
end
