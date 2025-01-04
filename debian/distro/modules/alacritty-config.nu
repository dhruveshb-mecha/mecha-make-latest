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
    log_debug $"Alacritty binary path: ($alacritty_bin)"

    let alacritty_config = $alacritty_package_path + "alacritty.yml"
    log_debug $"Alacritty configuration path: ($alacritty_config)"

    let alacritty_theme = $alacritty_package_path + "flat-remix.yml"
    log_debug $"Alacritty theme path: ($alacritty_theme)"
    
    let alacritty_dest = $"($rootfs_dir)/usr/bin/"
    let config_dir = $"($rootfs_dir)/home/mecha/.config"
    let config_dest = $"($config_dir)/alacritty"
    let theme_dest = $"($rootfs_dir)/home/mecha/.alacritty-theme/themes"

    # System-level configuration
    log_info "Installing alacritty binary..."
    SUDO cp $alacritty_bin $alacritty_dest
    log_debug "System binary installation completed successfully."

    # Make the binary executable
    SUDO chmod 755 $"($alacritty_dest)/alacritty"
    log_debug "Alacritty binary permissions set successfully."

    # User-level configuration
    log_info "Setting up user alacritty configuration..."
    
    # Create config directory if it doesn't exist
    if not ($config_dest | path exists) {
        log_debug $"Creating directory: ($config_dest)"
        mkdir -p $config_dest
    }
    
    # Copy configuration file
    log_debug $"Copying ($alacritty_config) to ($config_dest)"
    cp $alacritty_config $"($config_dest)/alacritty.yml"
    log_info "alacritty.yml copied successfully."

    # Create theme directory and copy theme
    log_info "Setting up Alacritty theme..."
    if not ($theme_dest | path exists) {
        log_debug $"Creating directory: ($theme_dest)"
        mkdir -p $theme_dest
    }
    
    # Copy theme file
    log_debug $"Copying ($alacritty_theme) to ($theme_dest)"
    cp $alacritty_theme $"($theme_dest)/flat-remix.yml"
    log_info "flat-remix.yml theme file copied successfully."

    log_debug "Alacritty configuration completed successfully."
}