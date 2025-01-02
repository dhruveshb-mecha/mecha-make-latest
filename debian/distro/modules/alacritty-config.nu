#!/usr/bin/env nu

use logger.nu

alias SUDO = sudo

export def configure_alacritty [] {
    log_info "Configuring system files:"
    let rootfs_dir = $env.ROOTFS_DIR
    let build_conf_path = $env.BUILD_CONF_PATH
    
    let script_dir_path = (open $build_conf_path | get include-path)
    let alacritty_package_path = $script_dir_path + "/alacritty/"
    let alacritty_bin = $alacritty_package_path + "alacritty"
    let alacritty_config = $alacritty_package_path + "alacritty.yml"
    let alacritty_theme = $alacritty_package_path + "flat-remix.yml"
    
    let alacritty_dest = $"($rootfs_dir)/usr/bin/"
    let config_dir = $"($rootfs_dir)/home/mecha/.config"
    let config_dest = $"($config_dir)/alacritty"
    let theme_dest = $"($rootfs_dir)/home/mecha/.alacritty-theme/themes"

    # System-level configuration
    SUDO cp $alacritty_bin $alacritty_dest
    log_debug "System files configured successfully."

    # User-level configuration
    log_info "Setting up user alacritty configuration..."
    
    # Create config directory
    mkdir $config_dest
    
    # Copy configuration file
    if (cp $alacritty_config $"($config_dest)/alacritty.yml") {
        log_info "alacritty.yml moved successfully."
    } else {
        log_error "Failed to move alacritty.yml. Please check file path."
        return 1
    }

    # Create theme directory and copy theme
    log_info "Setting up Alacritty theme..."
    mkdir $theme_dest
    
    # Copy theme file
    if (cp $alacritty_theme $"($theme_dest)/flat-remix.yml") {
        log_info "flat-remix.yml theme file moved successfully."
    } else {
        log_error "Failed to move flat-remix.yml. Please check file path."
        return 1
    }

    log_debug "User configuration completed successfully."
}