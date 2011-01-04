#
# Cookbook Name:: homebrew
# Recipe:: dbs
#

root = File.expand_path(File.join(File.dirname(__FILE__), ".."))

require root + '/resources/homebrew'
require root + '/providers/homebrew'

%w(tig ack coreutils imagemagick sqlite gist wget hub fortune proctools markdown ctags-exuberant).each do |pkg|
  homebrew pkg
end

template "#{ENV['HOME']}/.ackrc" do
  mode   0700
  owner  ENV['USER']
  group  Etc.getgrgid(Process.gid).name
  source "dot.ackrc.erb"
end
