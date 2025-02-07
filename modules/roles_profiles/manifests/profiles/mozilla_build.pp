# This Source Code Form is subject to the terms of the Mozilla Public
# License, v. 2.0. If a copy of the MPL was not distributed with this
# file, You can obtain one at http://mozilla.org/MPL/2.0/.

class roles_profiles::profiles::mozilla_build {

    case $::operatingsystem {
        'Windows': {

        $current_mozbld_ver = $facts['custom_win_mozbld_vesion'] # Determined in /modules/win_shared/facts.d/win_application_versions.ps1
        $needed_mozbld_ver  = '3.2'
        $current_hg_ver     = $facts['custom_win_hg_version'] # Determined in /modules/win_shared/facts.d/win_application_versions.ps1
        $needed_hg_ver      = '4.7.1'
        $install_path       = "${facts['custom_win_systemdrive']}\\mozilla-build"
        $system_drive       = $facts['custom_win_systemdrive']
        $cache_drive        = $facts['custom_win_location'] ? {
            'datacenter' => $system_drive,
            'aws'        => 'y:',
        }
        $program_files      = $facts['custom_win_programfiles']
        $programdata        = $facts['custom_win_programdata']
        $tempdir            = $facts['custom_win_temp_dir']
        $system32           = $facts['custom_win_system32']
        $external_source    = lookup('win_ext_pkg_src')
        $tooltool_tok       = lookup('tooltool_tok')

            class { 'win_mozilla_build':
                current_mozbld_ver => $current_mozbld_ver,
                needed_mozbld_ver  => $needed_mozbld_ver,
                current_hg_ver     => $current_hg_ver,
                needed_hg_ver      => $needed_hg_ver,
                install_path       => $install_path,
                system_drive       => $system_drive,
                cache_drive        => $cache_drive,
                program_files      => $program_files,
                programdata        => $programdata,
                tempdir            => $tempdir,
                system32           => $system32,
                external_source    => $external_source,
                builds_dir         => "${facts['custom_win_systemdrive']}\\builds",
                tooltool_tok       => $tooltool_tok,
            }
            # Bug List
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1524440
            # Mozilla Build Version
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1461340
            # Hg version
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1490703
            # Symlinks Support
            # https://bugzilla.mozilla.org/show_bug.cgi?id=1316329

        }
        default: {
            fail("${::operatingsystem} not supported")
        }
    }
}
