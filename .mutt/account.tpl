# vi: ft=muttrc

# Important: set all options to avoid overlap
# when switching accounts

{{range $index, $account := .accounts}}
# Account {{$account.name}}
set hostname = "{{if $account.host}}{{$account.host}}{{end}}"

# Receive options
set folder = {{if $account.folder}}{{$account.folder}}{{else}}imaps://{{$account.imap_host}}:{{$account.imap_port}}{{end}}
{{if $account.mailboxes}}mailboxes {{$account.mailboxes}}{{end}}
set imap_user = "{{$account.user}}"
set imap_pass = "{{$account.pass}}"

# Send options
set smtp_url = "smtps://$imap_user:$imap_pass@{{$account.smtp_host}}:{{$account.smtp_port}}"
# set smtp_pass = "{{$account.smtp_pass}}"
set realname = "{{$account.realname}}"
set from = "{{$account.from}}"
set signature = "{{$account.signature}}"

# Mailbox options
set spoolfile = "{{$account.spoolfile}}"
set postponed = "{{$account.postponed}}"
set record = "{{$account.record}}"
set trash = "{{$account.trash}}"
set move = "{{if $account.move}}yes{{else}}no{{end}}"

# TODO
# set attribution = "Le %d, %n a écrit :"
# set date_format = "!%d/%m/%Y %H:%M"
# set charset = "utf-8"
# set assumed_charset = "utf-8"
# set send_charset = "utf-8:iso-8859-15:us-ascii"

# Connection options
set certificate_file = "{{$account.certificate_file}}"
set smtp_authenticators = "{{$account.smtp_authenticators}}"
set ssl_force_tls = "{{if $account.ssl_force_tls}}yes{{else}}no{{end}}"
{{if not $account.ssl_starttls}}un{{end}}set ssl_starttls
{{if not $account.ssl_use_sslv2}}un{{end}}set ssl_use_sslv2
{{if not $account.ssl_use_sslv3}}un{{end}}set ssl_use_sslv3

# account-hook $folder "set imap_user=$imap_user imap_pass=$imap_pass"
{{end}}
