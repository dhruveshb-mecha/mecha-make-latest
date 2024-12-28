#!/usr/bin/env nu

use logger.nu

alias SUDO = sudo

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
    
    # Define the master preferences content
    let master_prefs_content = {
      "homepage": "http://www.google.com",
      "homepage_is_newtabpage": false,
      "browser": {
        "show_home_button": true,
        "confirm_to_quit": true  // Added: Ask for confirmation before closing
      },
      "session": {
        "restore_on_startup": 4,
        "startup_urls": ["http://www.google.com/"]
      },
      "bookmark_bar": {
        "show_on_all_tabs": false
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
        "verbose_logging": true
      },
      enable_touch_events: true,
      "first_run_tabs": [
        "https://mecha.so/",
        "http://new_tab_page"
      ]
    }
    
    # Define the policy content
    let policy_content = {
        HomepageLocation: "http://www.google.com/"
        RestoreOnStartup: 4
        DefaultSearchProviderSearchURL: "https://google.com/?q={searchTerms}"
        BlockOutdatedPlugins: true
        DisableJavaScript: false
        IncognitoModeAvailability: 1
        ForceDarkMode: true
        ShowHomeButton: true
        ForceFirstRun: true
        BrowserThemeColor: "#4B0082"
    }
    
    # Write master preferences file
    log_debug $"Writing master preferences to: ($master_prefs_file)"
    $master_prefs_content | to json | SUDO tee $master_prefs_file
    SUDO chmod 644 $master_prefs_file
    
    # Write policy file
    log_debug $"Writing policy file to: ($policy_file)"
    $policy_content | to json | SUDO tee $policy_file
    SUDO chmod 644 $policy_file
    
    log_info "Chromium configuration completed."
}