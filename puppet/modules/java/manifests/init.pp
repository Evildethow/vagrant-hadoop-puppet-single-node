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

  	file { "/usr/local/java":
	    ensure => 'link',
	    target => "/usr/lib/jvm/java-1.7.0-openjdk-1.7.0.71.x86_64/jre",
	    require => Package["java-1.7.0-openjdk.x86_64"],
	}
}