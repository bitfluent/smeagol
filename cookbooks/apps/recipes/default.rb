#
# Cookbook Name:: apps
# Recipe:: default
#
PREFIX = "#{ENV['HOME']}/Developer"

script "installed iterm2 from google code" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    if [ ! -e ~/Applications/iTerm2.app ]; then
      curl http://iterm2.googlecode.com/files/iTerm2-nightly-2011-03-22.zip -o iTerm2.zip
      unzip iTerm2.zip
      mv iTerm.app /Applications/
      rm iTerm2.zip
    fi
  EOS
end

script "installed gitx from github" do
  interpreter "bash"
  code <<-EOS
    source ~/.cinderella.profile
    if [ ! -e #{PREFIX}/bin/gitx ]; then
      curl -L http://cloud.github.com/downloads/kamal/gitx/gitx-blame.tar.gz -o - | tar xj -
      cd gitx-blame
      cp gitx #{PREFIX}/bin
      cp -R GitX.app /Applications
      defaults write nl.frim.GitX gitExecutable -string #{PREFIX}/bin/git
    fi
  EOS
end
