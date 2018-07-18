# vi: ft=msmtp
# /usr/share/vim/vimfiles/syntax/msmtp.vim

# Set default values for all following accounts.
defaults
auth           on
tls            on
tls_trust_file /etc/ssl/certs/ca-certificates.crt
logfile        ~/.msmtp.log

{{range $index, $account := .accounts}}
# Account {{$account.name}}
account        {{$account.name}}
host           {{$account.smtp_host}}
port           {{$account.smtp_port}}
from           {{$account.from}}
user           {{$account.user}}
password       {{$account.pass}}
{{end}}

# Set a default account
account default : {{.default}}{{/* index .accounts .default */}}
