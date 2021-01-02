#!/usr/bin/env ruby
contents = File.read('stylesheets/main.css.orig')
lines = contents.split(/[\r\n]/)
@newlines = []
@vars_found = []
@state = 0
lines.each do |line|
  if line =~ /^[\.#]?([a-zA-Z]\S+)\s*\{/
    @container = $1.gsub(/[ .]/, '_')
    @state = 1
  end

  if @state == 1 && line =~ /^(\s.*?)(\S*width):\s*(.*?);/
    pref = $1
    wid = $2
    val = $3
    var = "--#{@container}_#{wid.gsub(/[ .]/, '_')}"
    @vars_found << "#{var}: #{val};"
    @newlines << line
    @newlines << "#{pref}#{wid}: var(#{var});"
  else
    @newlines << line
  end
  @state = 0 if @state == 1 && line =~ /^\s*\}/
end
@vars_found.sort!
puts ":root {"
puts @vars_found.join("\n")
puts "}"
puts
puts @newlines.join("\n")
