class ntp {
    include ntp::install, ntp::config, ntp::service
}
class ntp::install {
    case $operatingsystem  {
        Scientific: {
            package { "ntp": ensure => latest }
        }
        CentOS: {
            package { "ntp": ensure => latest }
        }
        Debian: {
            package { "ntp": ensure => latest }
        }
        Ubuntu: {
            package { "ntp": ensure => latest }
        }
    }
}

class ntp::config {
    file{"/etc/ntp.conf":
        content => template("ntp/ntpconf.erb"),
        require => Class["ntp::install"]
    }
}

class ntp::service {
    $ntp_service = $operatingsystem ? {
        Debian     => "ntp",
        Ubuntu     => "ntp",
        Scientific => "ntpd",
        CentOS     => "ntpd",
    }
    service { $ntp_service:
        ensure  => running,
        enable  => true,
        require => Class["ntp::config"],
    }
}
