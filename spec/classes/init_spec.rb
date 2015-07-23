require 'spec_helper'
describe 'auditd', :type => :class do
  context 'default parameters on RedHat 7' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '7',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_class('auditd')
      should contain_package('audit').with({
        'ensure' => 'present',
      })
      should contain_file('/etc/audit/auditd.conf').with({
        'ensure' => 'file',
        'owner'  => 'root',
        'group'  => 'root',
        'mode'   => '0640',
      })
      should contain_concat('/etc/audit/rules.d/puppet.rules').with({
        'ensure'         => 'present',
        'owner'          => 'root',
        'group'          => 'root',
        'mode'           => '0640',
        'ensure_newline' => 'true',
        'warn'           => 'true',
        'alias'          => 'audit-file',
      })
      should contain_service('auditd').with({
        'ensure'    => 'running',
        'enable'    => 'true',
        'hasstatus' => 'true',
        'restart'   => '/usr/libexec/initscripts/legacy-actions/auditd/restart',
        'stop'      => '/usr/libexec/initscripts/legacy-actions/auditd/stop',
      })
    }
  end
  context 'default parameters on RedHat 6' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'default parameters on Amazon Linux' do
    let (:facts) {{
      :osfamily        => 'RedHat',
      :operatingsystem => 'Amazon',
      :concat_basedir  => '/var/lib/puppet/concat',
    }}
    it {
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'default parameters on Debian 8' do
    let (:facts) {{
      :osfamily          => 'Debian',
      :lsbmajdistrelease => '8',
      :concat_basedir    => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd')
      should contain_service('auditd').with({
        'restart' => '/bin/systemctl restart auditd',
        'stop'    => '/bin/systemctl stop auditd',
      })
    }
  end
  context 'default parameteres on Ubuntu 14.04' do
    let (:facts) {{
      :osfamily          => 'Debian',
      :operatingsystem   => 'Ubuntu',
      :lsbmajdistrelease => '14.04',
      :concat_basedir    => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('auditd')
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'default parameters on Archlinux' do
    let (:facts) {{
      :osfamily       => 'Archlinux',
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'audit',
      })
      should contain_service('auditd').with({
        'restart' => '/usr/bin/kill -s SIGHUP $(cat /var/run/auditd.pid)',
        'stop'    => '/usr/bin/kill -s SIGTERM $(cat /var/run/auditd.pid)',
      })
    }
  end
  context 'default parameters on Gentoo' do
    let (:facts) {{
      :osfamily       => 'Gentoo',
      :concat_basedir => '/var/lib/puppet/concat',
    }}
    it {
      should contain_package('audit').with({
        'name' => 'audit',
      })
      should contain_service('auditd').with({
        'restart' => '/etc/init.d/auditd restart',
        'stop'    => '/etc/init.d/auditd stop',
      })
    }
  end
  context 'with rules on RedHat 6' do
    let (:facts) {{
      :osfamily               => 'RedHat',
      :operatingsystemrelease => '6',
      :concat_basedir         => '/var/lib/puppet/concat',
    }}
    let (:params) {{
      :rules => {
        'delete other rules' => {
          'content' => '-D',
          'order'   => '00',
        },
        'watch for updates to users' => {
          'content' => '-w /etc/passwd -p wa -k identity',
          'order'   => '01',
        }
      }
    }}
    it {
      should contain_file('/etc/audit/audit.rules').with_content("-D\n-w /etc/passwd -p wa -k identity")
    }
  end
end
