install_browser_extensions() {
  local extensions=(
    "fdjamakpfbbddfjaooikfcpapjohcfmg|Dashlane"
  )

  local browsers=(
    "arc"
    "chrome"
  )

  if ! command -v extension >/dev/null 2>&1; then
    echo "Skipping browser extensions; extension CLI is not available"
    return
  fi

  browser_ext_path() {
    case "$1" in
      arc)    echo "$HOME/Library/Application Support/Arc/User Data/Default/Extensions" ;;
      chrome) echo "$HOME/Library/Application Support/Google/Chrome/Default/Extensions" ;;
    esac
  }

  ext_name_from_manifest() {
    local ext_dir="$1"
    python3 - "${ext_dir}" <<'PYEOF'
import sys, json, glob, os

ext_dir = sys.argv[1]
manifests = glob.glob(ext_dir + "/*/manifest.json")
if not manifests:
    print(os.path.basename(ext_dir))
    sys.exit()

d = json.load(open(manifests[0]))
name = d.get("name", "")

if name.startswith("__MSG_") and name.endswith("__"):
    key = name[6:-2].lower()
    default_locale = d.get("default_locale", "en")
    for locale in [default_locale, "en"]:
        for f in glob.glob(ext_dir + "/*/_locales/" + locale + "/messages.json"):
            try:
                msgs = json.load(open(f))
                for k, v in msgs.items():
                    if k.lower() == key:
                        print(v.get("message", name))
                        sys.exit()
            except Exception:
                pass

print(name if name else os.path.basename(ext_dir))
PYEOF
  }

  echo "Select browsers to manage extensions for:"
  local i=1
  for browser in "${browsers[@]}"; do
    echo "  ${i}) ${browser}"
    i=$((i + 1))
  done
  echo ""
  read -r -p "Enter numbers separated by spaces (e.g. 1 2) or 'all': " selection

  local selected_browsers=()
  if [[ "${selection}" == "all" ]]; then
    selected_browsers=("${browsers[@]}")
  else
    for num in ${selection}; do
      local idx=$((num - 1))
      if [[ ${idx} -ge 0 && ${idx} -lt ${#browsers[@]} ]]; then
        selected_browsers+=("${browsers[${idx}]}")
      else
        echo "Invalid selection: ${num}, skipping"
      fi
    done
  fi

  if [[ ${#selected_browsers[@]} -eq 0 ]]; then
    echo "No browsers selected."
    return
  fi

  for browser in "${selected_browsers[@]}"; do
    echo ""
    echo "Installing extensions for ${browser}..."
    for entry in "${extensions[@]}"; do
      local id="${entry%%|*}"
      local name="${entry#*|}"
      echo "  Installing ${name}..."
      extension install "${browser}" "${id}"
    done

    # Uninstall extensions not in the list
    local ext_path
    ext_path="$(browser_ext_path "${browser}")"
    if [[ ! -d "${ext_path}" ]]; then
      continue
    fi

    local to_uninstall=()
    for installed_id in "${ext_path}"/*/; do
      installed_id="$(basename "${installed_id}")"
      local keep=false
      for entry in "${extensions[@]}"; do
        local id="${entry%%|*}"
        if [[ "${installed_id}" == "${id}" ]]; then
          keep=true
          break
        fi
      done
      if [[ "${keep}" == false ]]; then
        to_uninstall+=("${installed_id}")
      fi
    done

    if [[ ${#to_uninstall[@]} -gt 0 ]]; then
      echo ""
      echo "The following ${browser} extensions are not in your list and will be uninstalled:"
      for id in "${to_uninstall[@]}"; do
        local display_name
        display_name="$(ext_name_from_manifest "${ext_path}/${id}")"
        echo "  - ${display_name} (${id})"
      done
      read -r -p "Proceed? [y/N] " confirm
      if [[ "$(echo "${confirm}" | tr '[:upper:]' '[:lower:]')" == "y" ]]; then
        for id in "${to_uninstall[@]}"; do
          echo "  Uninstalling ${id}..."
          rm -rf "${ext_path}/${id}"
        done
      else
        echo "Skipping uninstall for ${browser}."
      fi
    fi
  done
}
