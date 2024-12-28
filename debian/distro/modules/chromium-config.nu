export def configure_chromium_preferences [] {
    log_info "Configuring Chromium preferences:"
    let rootfs_dir = $env.ROOTFS_DIR
    
    # Define the paths relative to rootfs
    let master_prefs_dir = $"($rootfs_dir)/etc/chromium"
    let master_prefs_file = $"($master_prefs_dir)/master_preferences"
    let policies_dir = $"($rootfs_dir)/etc/chromium/policies/managed"
    let policy_file = $"($policies_dir)/chromium-policy.json"
    
    # Create directories if they don't exist
    for dir in [$master_prefs_dir $policies_dir] {
        if not ($dir | path exists) {
            log_debug $"Creating directory: ($dir)"
            SUDO mkdir -p $dir
        }
    }
    
    # Define the master preferences content as a string to ensure proper JSON format
    let master_prefs_content = '''{
        "homepage": "http://www.google.com",
        "homepage_is_newtabpage": false,
        "browser": {
            "show_home_button": true
        },
        "session": {
            "restore_on_startup": 4,
            "startup_urls": [
                "http://www.google.com/ig"
            ]
        },
        "bookmark_bar": {
            "show_on_all_tabs": true
        },
        "sync_promo": {
            "show_on_first_run_allowed": false
        },
        "distribution": {
            "import_bookmarks_from_file": "bookmarks.html",
            "import_bookmarks": true,
            "import_history": true,
            "import_home_page": true,
            "import_search_engine": true,
            "ping_delay": 60,
            "do_not_create_desktop_shortcut": true,
            "do_not_create_quick_launch_shortcut": true,
            "do_not_create_taskbar_shortcut": true,
            "do_not_launch_chrome": true,
            "do_not_register_for_update_launch": true,
            "make_chrome_default": true,
            "make_chrome_default_for_user": true,
            "system_level": true,
            "verbose_logging": true,
            "browser": {
                "confirm_to_quit": true
            }
        },
        "first_run_tabs": [
            "http://www.example.com",
            "http://new_tab_page"
        ]
    }'''
    
    # Define the policy content as a string to ensure proper JSON format
    let policy_content = '''{
        "HomepageLocation": "https://www.youtube.com",
        "RestoreOnStartup": 4,
        "DefaultSearchProviderSearchURL": "https://duckduckgo.com/?q={searchTerms}",
        "BlockOutdatedPlugins": true,
        "DisableJavaScript": false,
        "IncognitoModeAvailability": 1,
        "ForceDarkMode": true,
        "ShowHomeButton": true,
        "Color": "#4B0082",
        "ForceFirstRun": true,
        "BrowserThemeColor": "#4B0082"
    }'''
    
    # Write master preferences file
    log_debug $"Writing master preferences to: ($master_prefs_file)"
    echo $master_prefs_content | SUDO tee $master_prefs_file
    SUDO chmod 644 $master_prefs_file
    
    # Write policy file
    log_debug $"Writing policy file to: ($policy_file)"
    echo $policy_content | SUDO tee $policy_file
    SUDO chmod 644 $policy_file
    
    log_info "Chromium configuration completed."
}