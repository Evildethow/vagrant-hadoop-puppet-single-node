class hadoop($hadoop_version = '2.5.2') {

	$hadoop_dir = "hadoop-${hadoop_version}"
	$hadoop_archive = "${hadoop_dir}.tar.gz"
	$hadoop_url = "http://apache.mirror.uber.com.au/hadoop/common/hadoop-${hadoop_version}/${hadoop_archive}"
	$files_base_dir = "puppet:///modules/hadoop"

	exec { "iptables-save": 
		command => "service iptables save",
	}

	exec { "iptables-stop": 
		command => "service iptables stop",
		require => Exec["iptables-save"],
	}

	exec { "iptables-chkconfig-off": 
		command => "chkconfig iptables off",
		require => Exec["iptables-stop"],
	}

	package { "wget":
		ensure => "installed",
	}

	exec { "download-hadoop":
		command => "wget ${hadoop_url}",
		cwd => "/tmp",
		creates => "/tmp/${hadoop_archive}",
		require => Package["wget"],
	}

	exec { "unzip-hadoop": 
		command => "tar -xzf ${hadoop_archive} -C /usr/local",
		cwd => "/tmp",
		creates => "/usr/local/${hadoop_dir}",
		require => Exec["download-hadoop"],
	}

	file { "/usr/local/hadoop":
	    ensure => 'link',
	    target => "/usr/local/${hadoop_dir}",
	    require => Exec["unzip-hadoop"],
	}

  	file { "/usr/local/hadoop/etc":
	    ensure  => directory,
	    recurse => true,
	    source  => "${files_base_dir}/etc",
	    sourceselect => all,
	    require => File["/usr/local/hadoop"],
	}

	file { "/usr/local/hadoop/sbin/yarn-daemon.sh":
	    ensure => present,
	    source => "${files_base_dir}/yarn-daemon.sh",
	    require => File["/usr/local/hadoop"],
	    mode   => 755,
	}

	file { "/usr/local/hadoop/sbin/mr-jobhistory-daemon.sh":
	    ensure => present,
	    source => "${files_base_dir}/mr-jobhistory-daemon.sh",
	    require => File["/usr/local/hadoop"],
	    mode   => 755,
	}

	file { "/tmp/hadoop-namenode":
		ensure => directory,
		owner   => vagrant,
		group   => vagrant,
	}

	file { "/tmp/hadoop-logs":
		ensure => directory,
		owner   => vagrant,
		group   => vagrant,
	}

	file { "/tmp/hadoop-datanode":
		ensure => directory,
		owner   => vagrant,
		group   => vagrant,
	}

	file { "/usr/local/${hadoop_dir}/logs":
		ensure => directory,
		owner   => vagrant,
		group   => vagrant,
		require => File["/usr/local/hadoop"],
	}

	file { "/etc/profile.d/hadoop.sh":
	    ensure => present,
	    owner  => root,
	    group  => root,
	    mode   => 755,
	    source => "${files_base_dir}/hadoop.sh",
  	}

  	file { "/etc/init.d/hadoop":
	    ensure => present,
	    owner  => root,
	    group  => root,
	    mode   => 777,
	    source => "${files_base_dir}/hadoop",
  	}

  	exec { "chkconfig-hadoop": 
		command => "chkconfig --level 2345 hadoop on",
		require => File["/etc/init.d/hadoop"],
	}

	exec { "setup-namenode-hadoop": 
		command => "/usr/local/hadoop/bin/hdfs namenode -format myhadoop",
		require => [ File["/usr/local/hadoop"], File["/etc/profile.d/java.sh"] ],
		creates => "/tmp/hadoop-namenode/current",
	}

	service { "hadoop":
		enable => true,
		require => [ Exec["setup-namenode-hadoop"], Exec["iptables-stop"] ],
	}

	exec { "init-dfs-temp-dir-a-hadoop": 
		command => "/usr/local/hadoop/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -mkdir /tmp",
		require => [ File["/etc/init.d/hadoop"], Service["hadoop"] ],
	}

	exec { "init-dfs-temp-dir-b-hadoop": 
		command => "/usr/local/hadoop/bin/hdfs --config $HADOOP_PREFIX/etc/hadoop dfs -chmod -R 777 /tmp",
		require => Exec["init-dfs-temp-dir-a-hadoop"],
	}	
}