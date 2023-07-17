# installing brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# add path to brew
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile

# activate brew
source ~/.zprofile

brew install cask
brew update

# install git
brew install git

# configure git
# add git aliases
cat << EOF > ~/.gitconfig
[user]
	name = ime	
	email = imepriimek@gmail.com
[init]
	defaultBranch = main
[core]
	editor = code --wait
[filter "lfs"]
	clean = git-lfs clean -- %f
	smudge = git-lfs smudge -- %f
	process = git-lfs filter-process
	required = true

[alias]
    a = add
    alias = "!git config --get-regexp '^alias\\.' | awk -F '[ =]' '!/alias[[:space:]]/ { gsub(/--format=.*/, \"\"); gsub(/--pretty=.*/, \"\"); print substr($0, index($0,$2)) }'"
    br = branch --list --format='%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(contents:subject) %(color:green)(%(committerdate:relative)) [%(authorname)]' --sort=-committerdate
    c = commit
    lg = log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
    s = status -s
EOF

# write to .zlogin
cat <<EOF > ~/.zlogin
#~/.zlogin

{
  # Compile the completion dump to increase startup speed.
  zcompdump="\${XDG_CACHE_HOME:-\$HOME/.cache}/prezto/zcompdump"
  if [[ -s "\$zcompdump" && (! -s "\${zcompdump}.zwc" || "\$zcompdump" -nt "\${zcompdump}.zwc") ]]; then
    if command mkdir "\${zcompdump}.zwc.lock" 2>/dev/null; then
      zcompile "\$zcompdump"
      command rmdir  "\${zcompdump}.zwc.lock" 2>/dev/null
    fi
  fi
} &!
EOF

# configure the ~/.zshrc
cat <<EOF > ~/.zshrc
# ~/.zshrc

source ~/.config/sources

#thefuck terminal command fixing
eval $(thefuck --alias)

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

eval "$(starship init zsh)"
EOF

# check that shell is valid
cat <<EOF >>| ~/.zshenv
# ~/.zshenv

# Ensure that a non-login, non-interactive shell has a defined environment.
if [[ ( "$SHLVL" -eq 1 && ! -o LOGIN ) && -s "${ZDOTDIR:-$HOME}/.zprofile" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprofile"
fi
EOF

# update shell
source ~/.zshrc

# installing nvm
git clone https://github.com/nvm-sh/nvm.git ~/.nvm

source ~/.zshrc

nvm install node

# apple defaults configuration
defaults write com.apple.dock "tilesize" -int "28" &&
defaults write com.apple.dock "autohide" -bool "true" && 
defaults write com.apple.dock "autohide-time-modifier" -float "0" &&
defaults write com.apple.dock "autohide-delay" -float "0" &&
defaults write com.apple.finder "ShowPathbar" -bool "true" &&
defaults write com.apple.finder "FXRemoveOldTrashItems" -bool "true" &&
defaults write com.apple.finder CreateDesktop false &&
defaults write NSGlobalDomain "NSToolbarTitleViewRolloverDelay" -float "0" &&
defaults write com.apple.dock largesize -int "40"

# make changes take effect
killall Dock
killall Finder

# installing diffrent apps with brew
brew install --cask google-chrome
brew install docker 
brew install --cask intellij-idea
brew install --cask rectangle
brew install --cask appcleaner
brew install --cask visual-studio-code
brew install inso
brew install tree
brew install exa
brew install python
brew install speedtest-cli
brew install tmux

# enable the code . command for VS code
cat << EOF >> ~/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# Check the exit status
if [ $? -eq 0 ]; then
  echo "Script executed successfully"
  
  # Delete the script file
  rm -- "\$0"
else
  echo "An error occurred during script execution"
