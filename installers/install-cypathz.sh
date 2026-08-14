
#!/usr/bin/env bash

echo "Installing CyPathz..."

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

bin_path="$HOME/bin"
cy_path_file="$HOME/.cypathz"

mkdir -p "$bin_path"

if [ ! -f "$cy_path_file" ]; then
    touch "$cy_path_file"
fi

source_exe="$script_dir/../bin/Release/net10.0/linux-x64/publish/CyPathz"
target_exe="$bin_path/cypathz"

cp -f "$source_exe" "$target_exe"
chmod +x "$target_exe"

wrapper='
# >> CyPathz >>

export PATH="$HOME/bin:$PATH"

cy() {
    if [ "$#" -eq 1 ] && [ "$1" = "pathz" ]; then
        cypathz "$1"
        return
    fi

    if [ "$#" -eq 1 ]; then
        target="$(cypathz "$1")"

        if [ -d "$target" ]; then
            cd "$target"
        else
            echo "CyPath not found: $target"
        fi
    else
        cypathz "$@"
    fi
}

# << CyPathz <<
'

bashrc="$HOME/.bashrc"

if [ ! -f "$bashrc" ]; then
    touch "$bashrc"
fi

start_marker="# >> CyPathz >>"
end_marker="# << CyPathz <<"

if grep -qF "$start_marker" "$bashrc"; then
    temp_file="$(mktemp)"

    awk -v start="$start_marker" -v end="$end_marker" '
        $0 == start { skip=1; next }
        $0 == end   { skip=0; next }
        !skip
    ' "$bashrc" > "$temp_file"

    printf "\n%s\n" "$wrapper" >> "$temp_file"

    mv "$temp_file" "$bashrc"
else
    printf "\n%s\n" "$wrapper" >> "$bashrc"
fi

echo
echo "CyPathz successfully installed"
echo
echo ">>>>>    cy Commands     <<<<<"
echo
echo " cy add [name] >> add CyPath to current directory"
echo
echo " cy [name]     >> go to directory"
echo
echo " cy rm [name]  >> remove CyPath"
echo
echo " cy pathz      >> list current CyPathz"
echo
echo " cy add [name] [folderName/folderName/...] >> add CyPath relative to current directory"
echo
echo " cy add [name] [@/pathName/pathName/pathName...] >> add CyPath to entered absolute path"
echo
echo "Close and re-open terminal to complete installation OR run: source ~/.bashrc"