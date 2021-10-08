require 'yaml'

class Configuration
  def initialize
    @settings = YAML.load_file(File.join(ENV['GITHUB_WORKSPACE'], '/.screenshot/config.yaml'))
  end

  #
  # @return [Integer]
  #
  def port
    @settings['port'] || 8000
  end

  #
  # @return [Boolean]
  #
  def should_show_table
    @settings['table'] || false
  end

  #
  # @return [Array]
  #
  def browsers
    @settings['browsers'] || []
  end

  #
  # @return [Boolean]
  #
  def local?
    @settings['local'] || false
  end
end
