#!/usr/bin/env ruby

require "./tools/all.rb"

# print help
$stderr.puts("
Usage:
	$ #{File.basename(__FILE__)} name attack_name (n_traces=-1 byte=0 target=all(/0x??) expected_key=2b7e151628aed2a6abf7158809cf4f3c)

where
	0x?? target must be one of ...") or exit if ARGV[0].nil?

# load settings
settings = load_settings(ARGV[0])

arg_attn = ARGV[1]
arg_ntr = ARGV[2]
arg_byte = ARGV[3]
arg_target = ARGV[4]
arg_key = ARGV[5]

n_traces = (arg_ntr.to_i <= 0) ? settings[:n_traces] : arg_ntr.to_i
attack_byte = (0..15).include?(arg_byte.to_i) ? arg_byte.to_i : 0
target = arg_target.nil? ? "all" : arg_target
$stderr.puts("Warning: invalid expected key. Using deafult key #{GS[:default_key]}.") if !arg_key.nil? and (arg_key[/\H/] or arg_key.length > 32)
exp_key_str = arg_key.nil? ? GS[:default_key] : (!arg_key[/\H/] and arg_key.length == 32 ? arg_key : GS[:default_key])
exp_key = [exp_key_str].pack("H*").unpack("C*")

# prepare attack
path = "#{settings.attack_dir}/#{arg_attn}"
FileUtils.mkpath(path)

# run attack(s)
puts "Attacking #{attack_byte}. byte using #{n_traces} traces."

if target == "all"
	Dir["#{GS[:sboxes_dir]}/0b*"].each do |linfile|
		puts "\ttarget: #{File.basename linfile}"
		run_attack(settings, arg_attn, n_traces, attack_byte, File.basename(linfile), exp_key_str)
	end
else
	target_file = "#{GS[:sboxes_dir]}/#{target}"
	raise "Invalid target! (File #{GS[:sboxes_dir]}/#{target} does not exist.)" unless File.exists?(target_file)
	puts "\ttarget: #{target}"
	run_attack(settings, arg_attn, n_traces, attack_byte, target, exp_key_str)
end
