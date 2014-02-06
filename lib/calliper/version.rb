module Calliper
  def self.version
    Gem::Version.new File.read(File.expand_path('../../../VERSION', __FILE__))
  end

  module VERSION
    MAJOR, MINOR, TINY, PRE = Calliper.version.segments
    STRING = Calliper.version.to_s
  end
end
