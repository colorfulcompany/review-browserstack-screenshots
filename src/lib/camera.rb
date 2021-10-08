require 'screenshot'

class Camera
  def initialize(
    client: Screenshot::Client.new(username: ENV['INPUT_BROWSERSTACK_USERNAME'].strip, password: ENV['INPUT_BROWSERSTACK_ACCESS_KEY'].strip),
    preview_base_url: "https://www.browserstack.com/screenshots"
  )
    @client = client
    @preview_base_url = preview_base_url
  end

  #
  # @param [String] target_url
  # @param [Array] browsers
  # @param [Boolean] local
  # @param [Integer] port
  # @return [Array]
  #
  def take(target_url, browsers, local, port)
    job_id = @client.generate_screenshots(
      url: local ? "http://localhost:#{port}#{target_url}" : target_url,
      browsers: browsers,
      local: local
    )

    while 1
      @client.screenshots_done?(job_id) ? break : sleep(5)
    end

    [preview_url(job_id), @client.screenshots(job_id)]
  end

  #
  # @param [String] job_id
  # @return [String]
  #
  def preview_url(job_id)
    "#{@preview_base_url}/#{job_id}"
  end
end
