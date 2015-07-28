# == Class: nexus::plugins::rundeck
#
# Installs the Nexus Rundeck plugin
#
# === Parameters:
#
# [*md5*]
#   MD5 hash of the archive found at $source.
#
# [*nexus_work_dir*]
#   Full type to the sonatype work dir. (Typically ends with 
#   '../sonatype-work/nexus'.)
#
# [*source*]
#   URL to the plugin's bundle.zip
#
# [*version*]
#   The version of the plugin found at $source.
#
class nexus::plugins::rundeck (
  $md5            = undef,
  $nexus_work_dir = undef,
  $source,
  $version,
) {
  $real_nexus_work_dir = $nexus_work_dir ? {
    undef   => hiera( 'nexus::nexus_work_dir', undef ),
    default => $nexus_work_dir,
  }

  include ::unzip

  $archive_name = basename( $source, '.zip' )
  $root_dir     = "nexus-rundeck-plugin-${version}"
  $target_dir   = "${real_nexus_work_dir}/plugin-repository"

  archive { $archive_name:
    ensure        => present,
    checksum      => $md5 ? { undef => false, default => true, },
    digest_string => $md5,
    extension     => 'zip',
    root_dir      => $root_dir,
    target        => $target_dir,
    url           => $source,
    require       => Class['::unzip'],
    notify        => Service['nexus'],
  } ->

  file { "${target_dir}/${root_dir}":
    mode => '0755',
  }
}
