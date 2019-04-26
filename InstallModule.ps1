$fullPath = 'C:\Program Files\WindowsPowerShell\Modules\NameIT'

Robocopy . $fullPath /mir /XD .vscode .git examples testimonials images spikes /XF appveyor.yml .gitattributes .gitignore