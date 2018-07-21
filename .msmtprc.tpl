# vi: ft=msmtp
# /usr/share/vim/vimfiles/syntax/msmtp.vim

# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file {{.TLS_TRUST_FILE}}
logfile        ~/.msmtp.log
{{range $index, $account := .accounts}}
# {{title $account.name}} Account
account        {{$account.name}}
host           {{$account.smtp_host}}
port           {{$account.smtp_port}}
from           {{$account.from}}
user           {{or $account.smtp_user $account.user}}
{{if $account.pass_cmd -}}
passwordeval   "{{$account.pass_cmd}}"
{{else if or $account.smtp_pass $account.pass -}}
password       {{or $account.smtp_pass $account.pass}}
{{end -}}
{{end}}

# Set a default account
account default : {{.default}}{{/* index .accounts .default */}}
