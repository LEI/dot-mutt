# vi: ft=mbsyncrc

# ~/.mbsyncrc
{{range $index, $account := .accounts}}
# Account {{title $account.name}}
IMAPAccount {{$account.name}}
Host "{{$account.imap_host}}"
Port "{{$account.imap_port}}"
User "{{$account.user}}"{{if $account.pass}}
Pass "{{$account.pass}}"{{end}}{{if $account.pass_cmd}}
PassCmd "{{$account.pass_cmd}}"{{end}}
SSLType {{if $account.ssl_type}}{{$account.ssl_type}}{{else}}IMAPS{{end}}
AuthMechs {{if $account.auth_mecs}}{{$account.auth_mecs}}{{else}}LOGIN{{end}}{{if $account.certificate_file}}
CertificateFile "{{$account.certificate_file}}"{{end}}

IMAPStore {{$account.name}}-remote
Account {{$account.name}}

MaildirStore {{$account.name}}-local
#Subfolders Verbatim
# The trailing "/" is important
Path ~/.mail/{{$account.name}}/
Inbox ~/.mail/{{$account.name}}/inbox

Channel {{$account.name}}-default
Master :{{$account.name}}-remote:
Slave :{{$account.name}}-local:
Patterns {{if $account.patterns}}{{$account.patterns}}{{else}}INBOX{{end}}

{{range .channels -}}
Channel {{$account.name}}-{{.name}}
Master :{{$account.name}}-remote:"{{.remote}}"
Slave  :{{$account.name}}-local:{{.local}}{{if .patterns}}
Patterns {{.patterns}}
{{- end}}

{{end -}}
# Automatically create missing mailboxes, both locally and on the server
Create {{if $account.create}}{{$account.create}}{{else}}Both{{end}}
# Automatically delete messages on either side if they are found deleted on the other.
Expunge {{if $account.expunge}}{{$account.expunge}}{{else}}Both{{end}}
# Save the synchronization state files in the relevant directory
SyncState {{if $account.sync_state}}{{$account.sync_state}}{{else}}*{{end}}

Group {{$account.name}}{{range .channels}}
Channel {{$account.name}}-{{.name}}
{{- end}}
{{end -}}
