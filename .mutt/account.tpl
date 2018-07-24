# vi: ft=muttrc
{{- /* https://github.com/ork/mutt-office365/blob/master/lang/en_US */}}

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
    source "~/.mutt/scripts/mutt-set my_pass {{$account.pass_cmd}} |"; \
    set imap_pass = $my_pass;'
    {{else -}}
    set imap_pass = "{{$account.pass}}";'
    {{end -}}
# Send options
# FIXME: custom sendmail script
folder-hook '{{$account.name}}' '\
    set folder = "{{$folder}}"; \
    {{if $account.folder -}}
    unset smtp_url; \
    unset smtp_pass; \
    set sendmail = "$HOME/.mutt/scripts/mutt-send --account {{$account.name}}"; \
    set sendmail_wait = -1; \
    {{else -}}
    set smtp_url = smtps://{{if $account.smtp_user}}{{$account.smtp_user}}{{else}}$imap_user{{end}}@{{$account.smtp_host}}:{{$account.smtp_port}}; \
    set smtp_pass = {{if $account.smtp_pass}}{{$account.smtp_pass}}{{else}}$my_pass{{end}}; \
    unset sendmail; \
    unset sendmail_wait; \
    {{end -}}
    set realname = "{{$account.realname}}"; \
    set from = "{{$account.from}}"; \
    {{if not $account.alternates}}un{{end}}alternates "{{or $account.alternates "*"}}"; \
    set signature = "{{$account.signature}}"; \
    set use_from = {{if $account.use_from}}yes{{else}}no{{end}}; \
    set use_envelope_from = {{if $account.use_envelope_from}}yes{{else}}no{{end}};'
# Mailbox options
# set mbox = "";
folder-hook '{{$account.name}}' '\
    set spoolfile = "{{$account.spoolfile}}"; \
    set postponed = "{{$account.postponed}}"; \
    set record = "{{$account.record}}"; \
    set trash = "{{$account.trash}}"; \
    unmailboxes *; \
    mailboxes {{if $account.mailboxes}}{{$account.mailboxes}}{{else}}`find {{$account.folder}} -mindepth 1 -maxdepth 1 -type d -exec bash -c "printf \" +%s\" \"$(basename {})\"" \;`{{end}}; \
    set move = {{if $account.move}}yes{{else}}no{{end}}; \
    macro index S "<shell-escape>mbsync -V {{$account.name}}<return>" "mbsync"'
# {{if not $account.mailboxes}}un{{end}}mailboxes {{or $account.mailboxes "*"}};
# set attribution = "Le %d, %n a écrit :";
# set date_format = "!%d/%m/%Y %H:%M";
# set charset = "utf-8";
# set assumed_charset = "utf-8";
# set send_charset = "utf-8:iso-8859-15:us-ascii";
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
# mbsync --all --quiet
macro index <f{{add 2 $index}}> '<sync-mailbox>\
<shell-escape>mbsync -V {{$account.name}}<return>\
<enter-command>set folder = {{$folder}}<enter>\
<enter-command>set spoolfile = {{$account.spoolfile}}<enter>\
<change-folder>!<enter>'
{{- end}}
