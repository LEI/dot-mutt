# vi: ft=mbsyncrc

# ~/.mbsyncrc
{{range $name, $account := .accounts}}
IMAPAccount {{$name}}
Host "{{$account.imap_host}}"
Port "{{$account.imap_port}}"
User "{{$account.user}}"{{if $account.pass}}
Pass "{{$account.pass}}"{{end}}{{if $account.pass_cmd}}
PassCmd "{{$account.pass_cmd}}"{{end}}
SSLType {{if $account.ssl_type}}{{$account.ssl_type}}{{else}}IMAPS{{end}}
AuthMechs {{if $account.auth_mecs}}{{$account.auth_mecs}}{{else}}LOGIN{{end}}{{if $account.certificate_file}}
CertificateFile "{{$account.certificate_file}}"{{end}}

IMAPStore {{$name}}-remote
Account {{$name}}

MaildirStore {{$name}}-local
#Subfolders Verbatim
# The trailing "/" is important
Path ~/.mail/{{$name}}/
Inbox ~/.mail/{{$name}}/inbox

Channel {{$name}}-default
Master :{{$name}}-remote:
Slave :{{$name}}-local:
Patterns {{if $account.patterns}}{{$account.patterns}}{{else}}INBOX{{end}}

{{range .channels -}}
Channel {{$name}}-{{.name}}
Master :{{$name}}-remote:"{{.remote}}"
Slave  :{{$name}}-local:{{.local}}{{if .patterns}}
Patterns {{.patterns}}
{{- end}}

{{end -}}
# Automatically create missing mailboxes, both locally and on the server
Create {{if $account.create}}{{$account.create}}{{else}}Both{{end}}
# Automatically delete messages on either side if they are found deleted on the other.
Expunge {{if $account.expunge}}{{$account.expunge}}{{else}}Both{{end}}
# Save the synchronization state files in the relevant directory
SyncState {{if $account.sync_state}}{{$account.sync_state}}{{else}}*{{end}}

Group {{$name}}{{range .channels}}
Channel {{$name}}-{{.name}}
{{- end}}
{{end -}}
