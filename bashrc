# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines in the history. See bash(1) for more options
# don't overwrite GNU Midnight Commander's setting of `ignorespace'.
export HISTCONTROL=$HISTCONTROL${HISTCONTROL+,}ignoredups
# ... or force ignoredups and ignorespace
export HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "$debian_chroot" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
#	PS1='($?)${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
	PS1='($?)${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    	PS1='($?)${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]"$PS1
    ;;
*)
    ;;
esac



# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    eval "`dircolors -b`"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'
alias vaiporra='make -C $SOURCE_PATH rc kill clean cleandir++ && make -C $SOURCE_PATH rall'
alias bdb='$(make -C $HOME/bomnegocio rinfo | grep -e "^psql")'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
fi

### MY ADS
HISTSIZE=10000000
HISTFILESIZE=100000000

alias ls='ls -GpF'
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
export LESS='-R#3'
export PYTHONSTARTUP="$HOME/.pyrc"
export PSQL_EDITOR='vim +"set syntax=sql" '

if [ -f ~/.initdir ]; then cd `cat ~/.initdir`; fi

#VIM on mac
if [[ `hostname | grep 'Mac\|mbp'`  ]]; then
	true
#	export VIMRUNTIME=/usr/share/vim/vim74
#	export VIM=~/.vim
fi
# User specific aliases and functions

# BOM NEGOCIO
if [[ `hostname | grep office` ]]; then
	set -o vi
	export BN_SRC_PATH=~/bomnegocio
#export PYTHONPATH=$PYTHONPATH:$BN_SRC_PATH/lib/python/blocket_libs
	export PATH=$PATH:/opt/python/bin:~/bn_util/bin
	export LC_CTYPE=en_US.iso-8859-1
	export LANG=en_US.iso-8859-1
	MD=mobuyers_dev
	MS=mobuyers_stable
	MR=mobuyers_release
	SOURCE_PATH=~/bomnegocio
#GIT
# git completion
	if [ -f /etc/bash_completion.d/git-completion.bash ]; then
		source /etc/bash_completion.d/git-completion.bash
	fi

# git branch
	parse_git_branch() {
		TEMP=$? #So pra guardar o $?
		git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/'
		(exit $TEMP)
	}
	PS1="\$(parse_git_branch)"$PS1
	if [ -f ~/.rvm/scripts/rvm ]; then source ~/.rvm/scripts/rvm; fi


fi

##
# Your previous /Users/fred/.bash_profile file was backed up as /Users/fred/.bash_profile.macports-saved_2013-10-28_at_10:42:41
##

# MacPorts Installer addition on 2013-10-28_at_10:42:41: adding an appropriate PATH variable for use with MacPorts.
export PATH=/opt/local/bin:/opt/local/sbin:$PATH
# Finished adapting your PATH environment variable for use with MacPorts.


PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting

PATH=$PATH:$HOME/bin

function trans() {
trans_port=$(genport 5)
printf "cmd:$(echo "$@" | tr ' ' '\n' | tr '\#' ' ')\ncommit:1\nend\n---\n"
printf "cmd:$(echo "$@" | tr ' ' '\n' | tr '\#' ' ')\ncommit:1\nend\n" | nc localhost ${trans_port}
		}
		# Helper function to get regress ports
		function genport() {
		echo $(expr \( $(id -u) - \( $(id -u) / 100 \) \* 100 \) \* 200 + 20000 + ${1})
	}

	function bconf() {
	trans bconf | perl -ne 'next unless /^\s*conf:[*\w.-]+'"$@"'[\w.-]/; s/('"$@"')/\033[1;31m$1\033[m/g; print'
}
alias bdb='$(make -C $HOME/bomnegocio rinfo | grep -e "^psql")'
alias redis_account='$(make rinfo | grep "redis accounts server" | perl -pe "s/ - redis accounts server//g")'
alias redis_linkmanager='$(make rinfo | grep "redis link manager server" | perl -F"\s+-\s+" -nale "print @F[0]")'
alias redis_paymentapi='$(make rinfo | grep "redis payment api server" | perl -F"\s+-\s+" -nale "print @F[0]")'
alias redis_mobile='$(make rinfo | grep "redismobile server" | perl -F"\s+-\s+" -nale "print @F[0]")'
alias redis_fav='$(make rinfo | grep "redis favorites server" | perl -F"\s+-\s+" -nale "print @F[0]")'
alias flushdb='echo flushdb | redis_account'
alias makesfa='make -C ~/bomnegocio rc kill clean cleandir cleandir++ && ~/bomnegocio/compile.sh && make -C ~/bomnegocio rall'
alias gerastage='make -C ~/bomnegocio rc kill && make -C ~/bomnegocio clean cleandir cleandir++ && rm -rf rpm/{ia32e,noarch} && make -C ~/bomnegocio rpm-build-staging'
alias bdbstage='psql -h 172.16.1.59 -U postgres blocketdb'
alias makequasetudo='make rept reml remt rp ti rb rw'
alias rodameufilho='make -C ../.. rall && make -C ../.. rc kill && make rc rd && make selenium_stop selenium_start'
alias andaselenium='make selenium_stop selenium_start'
alias liga_xiti='trans bconf_overwrite key:*.*.common.stat_counter.xiti.display value:1 && make apache-regress-restart'

function trans() {
trans_port=$(genport 5)
printf "cmd:$(echo "$@" | tr ' ' '\n' | tr '\#' ' ')\ncommit:1\nend\n---\n"
printf "cmd:$(echo "$@" | tr ' ' '\n' | tr '\#' ' ')\ncommit:1\nend\n" | nc localhost ${trans_port}
}
# Biblioteca com utilitario (ex: chamada de trans)
alias admin_token='trans authenticate username:dev passwd:da39a3ee5e6b4b0d3255bfef95601890afd80709 remote_addr:127.0.0.1 | grep token'
function trans_admin() {
trans $* $(admin_token) remote_addr:127.0.0.1
}

# Helper function to get regress ports
function genport() {
echo $(expr \( $(id -u) - \( $(id -u) / 100 \) \* 100 \) \* 200 + 20000 + ${1})
}

function binfo { grep -i "\b$1\b\s*:" $HOME/bomnegocio/rpm/blocket.spec; }
function easyad_key_for_acc {
trans link_hash_manager_create_hash identifier:account_id=$1 type:EASYAD keys:account_id values:$1 | egrep 'hash:[a-f0-9]{40}' || echo error
}

function gitdiffbw { 
git difftool -y $1:$2 $2 
}

function gitdiffb { 
if [[ -z "$3" ]]; then 
	git difftool -y $1:$2 $(parse_git_branch):$2 
else 
	git difftool -y $1:$2 $(parse_git_branch):$3 
fi 
}

function expire_ad_staging(){
if [ "$#" -lt 1 ]; then
	echo "Usage: expire_ad [list_id]";
	return
fi

printf "cmd:deletead\nid:"$1"\nmonthly:1\nreason:expired_deleted\ncommit:1\nend\n" | nc 172.16.0.240 5656  > .expire_ad_temp
ad_id=`psql -h 172.16.1.59 -U postgres blocketdb -c "select ad_id from ads where list_id = $1;" -t`
if [ "$(grep TRANS_ERROR .expire_ad_temp -i)" == "" ]; then
	printf "cmd:admail\nad_id:$ad_id\nmail_type:deleted_monthly\ncommit:1\nend\n" | nc 172.16.0.240 5656
fi

cat .expire_ad_temp
rm .expire_ad_temp
}

function expire_ad(){
if [ "$#" -lt 1 ]; then
	echo "Usage: expire_ad [list_id]";
	return
fi

printf "cmd:deletead\nid:"$1"\nmonthly:1\nreason:expired_deleted\ncommit:1\nend\n" | nc localhost $(genport 5)  > .expire_ad_temp
if [ "$(grep TRANS_ERROR .expire_ad_temp -i)" == "" ]; then
	printf "cmd:flushqueue\nqueue:monthly_deleted\ncommit:1\nend\n" | nc localhost $(genport 5)
fi

cat .expire_ad_temp
rm .expire_ad_temp
}

export PSQL_EDITOR='vim +"set syntax=sql" '
