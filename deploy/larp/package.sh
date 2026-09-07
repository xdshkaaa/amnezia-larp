#!/bin/bash
# Run from any directory after cmake --build --preset larp-macos.
set -euo pipefail
source_dir=$(cd "$(dirname "$0")/../.." && pwd)
build_dir="$source_dir/build-larp"
output_dir="$source_dir/dist"
stage_dir=$(mktemp -d "${TMPDIR:-/tmp}/larp-package.XXXXXX")
trap 'if [[ $? -eq 0 ]]; then rm -rf "$stage_dir"; else echo "Packaging failed; staging preserved at $stage_dir" >&2; fi' EXIT
mkdir -p "$output_dir" "$stage_dir/root/Applications" "$stage_dir/scripts" "$stage_dir/dmg"
cmake --install "$build_dir" --prefix "$stage_dir/root/Applications" --component AmneziaVPN
app_path="$stage_dir/root/Applications/LarpmneziaVPN.app"
cp "$source_dir/deploy/larp/org.larp.LarpmneziaVPN.plist" "$app_path/Contents/Resources/"
# Keep non-code directories outside Contents/MacOS for Apple code signing.
mv "$app_path/Contents/MacOS/pf" "$app_path/Contents/Resources/pf"
ln -s ../Resources/pf "$app_path/Contents/MacOS/pf"
for resource in geoip.dat geosite.dat update-resolv-conf.sh; do
    if [[ -f "$app_path/Contents/MacOS/$resource" ]]; then
        mv "$app_path/Contents/MacOS/$resource" "$app_path/Contents/Resources/$resource"
        ln -s "../Resources/$resource" "$app_path/Contents/MacOS/$resource"
    fi
done
"$source_dir/.tools/Qt/6.10.1/macos/bin/macdeployqt" "$app_path" \
    -executable="$app_path/Contents/MacOS/LarpmneziaVPN-service" -always-overwrite
cp "$source_dir/LICENSE" "$app_path/Contents/Resources/LICENSE.txt"
cp "$source_dir/THIRD_PARTY_LICENSES.md" "$app_path/Contents/Resources/"
cp "$source_dir/deploy/larp/postinstall" "$stage_dir/scripts/postinstall"
chmod 755 "$stage_dir/scripts/postinstall"
# Sign nested code inside-out after all deployment and install-name changes.
find "$app_path" -type f -print0 | while IFS= read -r -d '' binary; do
    [[ "$binary" == "$app_path/Contents/MacOS/LarpmneziaVPN" ]] && continue
    if file -b "$binary" | /usr/bin/grep -q 'Mach-O'; then
        codesign --force --sign - "$binary"
    fi
done
find "$app_path" -depth -type d \( -name '*.framework' -o -name '*.app' \) -print0 | while IFS= read -r -d '' bundle; do
    codesign --force --sign - "$bundle"
done
codesign --verify --deep --strict "$app_path"
pkgbuild --root "$stage_dir/root" --scripts "$stage_dir/scripts" \
    --identifier org.larp.LarpmneziaVPN.test --version 5.0.2.1 --install-location / \
    "$stage_dir/dmg/LarpmneziaVPN-test.pkg"
cp "$source_dir/deploy/larp/README.txt" "$stage_dir/dmg/Прочитайте перед установкой.txt"
cp "$source_dir/LICENSE" "$stage_dir/dmg/LICENSE.txt"
hdiutil create -volname LarpmneziaVPN -srcfolder "$stage_dir/dmg" -ov -format UDZO "$output_dir/LarpmneziaVPN-test.dmg"
hdiutil verify "$output_dir/LarpmneziaVPN-test.dmg"
shasum -a 256 "$output_dir/LarpmneziaVPN-test.dmg" > "$output_dir/LarpmneziaVPN-test.dmg.sha256"
