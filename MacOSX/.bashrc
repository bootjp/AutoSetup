alias ll='ls -laG'
source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true
export PS1='\[\033[32m\]\u@\h\[\033[00m\]:\[\033[34m\]\w\[\033[31m\]$(__git_ps1)\[\033[00m\]\n\$ '
export HISTCONTROL=ignoredups:erasedups
export HISTSIZE=100000
export HISTFILESIZE=100000
shopt -s histappend
alias mecajavac='env DYLD_LIBRARY_PATH=".:/usr/local/bin/mecab-java" CLASSPATH=".:$CLASSPATH:/usr/local/bin/mecab-java/MeCab.jar" javac'
alias mecajava='env DYLD_LIBRARY_PATH=".:/usr/local/bin/mecab-java" CLASSPATH=".:$CLASSPATH:/usr/local/bin/mecab-java/MeCab.jar" java'
