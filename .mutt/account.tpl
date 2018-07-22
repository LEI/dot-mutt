# vi: ft=muttrc

# Important: set all options to avoid overlap
# when switching accounts
{{- range $index, $account := .accounts}}

# {{title $account.name}} Account
{{$folder := or $account.folder (print "imaps://" $account.imap_host ":" $account.imap_port)}}
{{if not $index -}}
# FIXME: default account hook
set folder = {{$folder}}
set spoolfile = {{$account.spoolfile}}
{{end -}}
folder-hook '{{$account.name}}' '\
    set hostname = '{{if $account.hostname}}{{$account.hostname}}{{end}}';'
# Receive options
folder-hook '{{$account.name}}' '\
    set folder = "{{$folder}}"; \
    set imap_user = {{$account.user}}; \
    {{if $account.pass_cmd -}}
    source "~/.mutt/scripts/set-my pass {{$account.pass_cmd}} |"; \
    set imap_pass = $my_pass;'
    {{else -}}
    set imap_pass = "{{$account.pass}}";'
    {{end -}}
# Send options
folder-hook '{{$account.name}}' '\
    set folder = "{{$folder}}"; \
    set smtp_url = smtps://{{if $account.smtp_user}}{{$account.smtp_user}}{{else}}$imap_user{{end}}@{{$account.smtp_host}}:{{$account.smtp_port}}; \
    set smtp_pass = {{if $account.smtp_pass}}{{$account.smtp_pass}}{{else}}$my_pass{{end}}; \
    set sendmail = "~/.mutt/scripts/msmtpq --account {{$account.name}}"; \
    set sendmail_wait = -1; \
    set realname = "{{$account.realname}}"; \
    set from = "{{$account.from}}"; \
    set signature = "{{$account.signature}}"; \
    set use_from = {{if $account.use_from}}yes{{else}}no{{end}}; \
    set envelope_from = {{if $account.envelope_from}}yes{{else}}no{{end}};'
# Mailbox options
# set mbox = "";
#{{if not $account.mailboxes}}un{{end}}mailboxes {{or $account.mailboxes "*"}}; \
folder-hook '{{$account.name}}' '\
    set spoolfile = "{{$account.spoolfile}}"; \
    set postponed = "{{$account.postponed}}"; \
    set record = "{{$account.record}}"; \
    set trash = "{{$account.trash}}"; \
    set move = {{if $account.move}}yes{{else}}no{{end}};'
# set attribution = "Le %d, %n a écrit :"; \
# set date_format = "!%d/%m/%Y %H:%M"; \
# set charset = "utf-8"; \
# set assumed_charset = "utf-8"; \
# set send_charset = "utf-8:iso-8859-15:us-ascii"; \
# Connection options
folder-hook '{{$account.name}}' '\
    set certificate_file = "{{or $account.certificate_file ""}}"; \
    set smtp_authenticators = "{{$account.smtp_authenticators}}"; \
    set ssl_force_tls = {{if $account.ssl_force_tls}}yes{{else}}no{{end}}; \
    {{if not $account.ssl_starttls}}un{{end}}set ssl_starttls; \
    {{if not $account.ssl_use_sslv2}}un{{end}}set ssl_use_sslv2; \
    {{if not $account.ssl_use_sslv3}}un{{end}}set ssl_use_sslv3;'
# macro index <f4> '<sync-mailbox><enter-command>~/.mutt/{{$account.name}}<enter><change-folder>!<enter>'
# account-hook $folder 'set imap_user=$imap_user imap_pass=$imap_pass'
# folder-hook '{{$folder}}' 'unmailboxes *; mailboxes {{$account.spoolfile}}{{if $account.channels}}{{range $channel := $account.channels}} {{$channel.local}}{{end}}{{else}} {{$account.postponed}} {{$account.record}} {{$account.trash}}{{end}}'
folder-hook '{{$folder}}' '\
    unmailboxes *; \
    mailboxes {{if $account.mailboxes}}{{$account.mailboxes}}{{else}}`find {{$account.folder}} -mindepth 1 -maxdepth 1 -type d -exec echo -n " +{}" \;`{{end}}'
#<shell-escape>mbsync -V -a {{$account.name}}<return>
macro index <f{{add 2 $index}}> '<sync-mailbox>\
<enter-command>set folder = {{$folder}}<enter>\
<enter-command>set spoolfile = {{$account.spoolfile}}<enter>\
<change-folder>!<enter>'
{{- end}}
