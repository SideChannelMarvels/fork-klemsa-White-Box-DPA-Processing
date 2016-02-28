require "open3"
require "fileutils"
require "yaml"
require "set"

Dir["./tools/*.rb"].each{|file| require file }

GS = YAML.load(File.read("glob_settings.yaml"))

ACQ_FILE = "acquire.rb"
MANFLT_FILE = "addr_row_filter.rb"
MANVIEW_FILE = "manual_view.rb"
ATTACK_FILE = "attack_n_mark.rb"

class Settings
	attr_reader :hash
	
	def initialize(hash)
		@hash = hash
	end
	def reload(hash)
		@hash = hash
	end
	
	def has_key?(key)
		@hash.has_key?(key)
	end
	def [](key)
		$stderr.puts("# Warning: uninitialized key \"#{key.to_s}\" accessed!") unless has_key?(key)
		@hash[key]
	end
	def []=(key, value)
		@hash[key] = value
	end
end
