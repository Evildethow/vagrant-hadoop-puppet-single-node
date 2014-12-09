class java() {	

	$files_base_dir = "puppet:///modules/java"

	package { "java-1.7.0-openjdk.x86_64":
	    ensure => "installed",
	}

	file { "/etc/profile.d/java.sh":
	    ensure => present,
	    owner  => root,
	    group  => root,
	    mode   => 755,
	    source => "${files_base_dir}/java.sh",
  	}
}