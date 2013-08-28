# -*- encoding: utf-8 -*-

class Remainder
  def initialize(dir)
    @previous_dir = dir
    @previous_dirs = dir.split("/")
  end

  def set_previous(dir)
    @previous_dir = dir
    @previous_dirs = dir.split("/")
  end

  def get_remain(dir)
    new_dirs = dir.split("/")
    new_dirs = [] if new_dirs == nil
    match_dirs = []
    level = 0
    @previous_dirs.each do |dir|
      if dir == new_dirs[level]
        match_dirs.push(dir)
      end
      level += 1
      if new_dirs.size < level
        break
      end
    end
    @org_dirs = new_dirs
    return match_dirs.join("/")
  end
end

remainder = Remainder.new("")
while line = ARGF.gets
  line = line.chomp
  remain_reg = Regexp.new(remainder.get_remain(line))
  remain_bytesize = remainder.get_remain(line).bytesize
  puts line.sub(remain_reg, " " * remain_bytesize)
  remainder.set_previous(line)
end
