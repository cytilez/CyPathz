## Install

### Windows x64 — PowerShell

```powershell
irm https://raw.githubusercontent.com/cytilez/CyPathz/main/installers/install-cypathz.ps1 | iex
```

### Linux x64 — Bash

```bash
curl -fsSL https://raw.githubusercontent.com/cytilez/CyPathz/main/installers/install-cypathz.sh | bash && source ~/.bashrc
```

CyPathz is a path shortcut tool, for quickly jumping between directories 
in Powershell and Bash.

It a simple script that lets you store a path to a name, and then call that 
name to get stright into the directory.

the comandlit is 'cy'

then  'cy add Doc' will store 'Doc' at the current directory
then  'cy Doc' will take you straigh to that directory

The full Comanlit list is 

cy add name  -   store path to name
cy rm  name  -   remove path and name
cy name      -   go to name directory
cy pathz     -   show current path names

cy add name /Documnets/Projects/CyPathz - store name to path from current+enterd path
cy add name @C:/Users/User/OneDeive/Desktop/Projects - store name to enterd path
