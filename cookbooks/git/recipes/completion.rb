#
# Cookbook Name:: git
# Recipe:: completion
#

root = File.expand_path(File.join(File.dirname(__FILE__), "..", "..", "homebrew"))

require root + '/resources/homebrew'
require root + '/providers/homebrew'

PREFIX   = "#{ENV['HOME']}/Developer"
HOMEBREW = "#{PREFIX}/bin/brew"

homebrew "bash-completion"

# Get installed version
git_version             = %x{#{HOMEBREW} info git | grep files | tail -n2 | head -n1 | awk '{print $1}'}.chomp.split("/").last
bash_completion_version = %x{#{HOMEBREW} info bash-completion | grep files | tail -n2 | head -n1 | awk '{print $1}'}.chomp.split("/").last

link "#{PREFIX}/Cellar/bash-completion/#{bash_completion_version}/etc/bash_completion.d/git" do
  to "#{PREFIX}/Cellar/git/#{git_version}/etc/bash_completion.d/git-completion.bash"
end

# Source bash_completion
%w(bash_profile bashrc zshrc).each do |config_file|
  execute "include bash-completion sourcing into defaults for ~/.#{config_file}" do
    command "if [ -f ~/.#{config_file} ]; then echo 'source `#{HOMEBREW} --prefix`/etc/bash_completion' >> ~/.#{config_file}; fi"
    not_if  "grep -q 'bash_completion' ~/.#{config_file}"
  end
end

execute "setup bash-completion profile sourcing in ~/.profile" do
  command "echo 'source `#{HOMEBREW} --prefix`/etc/bash_completion' >> ~/.profile"
  not_if  "grep -q 'bash_completion' ~/.profile"
end


# Set up PS1
%w(bash_profile bashrc zshrc).each do |config_file|
  execute "configure git-aware PS1 into defaults for ~/.#{config_file}" do
    # PS1='\h:\W \u $(__git_ps1 " (%s)")\$ '
    command %Q{if [ -f ~/.#{config_file} ]; then echo 'PS1=\'[\\u@\h \W\$(__git_ps1 " (%s)")]\$ \'' >> ~/.#{config_file}; fi}
    #not_if  "grep -q 'PS1' ~/.#{config_file}"
  end
end

execute "setup bash-completion profile sourcing in ~/.profile" do
   # PS1='\h:\W \u $(__git_ps1 " (%s)")\$ '
  command %Q{echo 'PS1=\'[\\u@\h \W\$(__git_ps1 " (%s)")]\$ \'' >> ~/.profile}
  #not_if  "grep -q 'PS1' ~/.profile"
end

