require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'
require 'beaker/puppet_install_helper'
require 'winrm'
require 'pry'

# automatically load any shared examples or contexts
Dir["./spec/support/**/*.rb"].sort.each { |f| require f }

GEOTRUST_GLOBAL_CA = <<-EOM.freeze
-----BEGIN CERTIFICATE-----
MIIDVDCCAjygAwIBAgIDAjRWMA0GCSqGSIb3DQEBBQUAMEIxCzAJBgNVBAYTAlVT
MRYwFAYDVQQKEw1HZW9UcnVzdCBJbmMuMRswGQYDVQQDExJHZW9UcnVzdCBHbG9i
YWwgQ0EwHhcNMDIwNTIxMDQwMDAwWhcNMjIwNTIxMDQwMDAwWjBCMQswCQYDVQQG
EwJVUzEWMBQGA1UEChMNR2VvVHJ1c3QgSW5jLjEbMBkGA1UEAxMSR2VvVHJ1c3Qg
R2xvYmFsIENBMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA2swYYzD9
9BcjGlZ+W988bDjkcbd4kdS8odhM+KhDtgPpTSEHCIjaWC9mOSm9BXiLnTjoBbdq
fnGk5sRgprDvgOSJKA+eJdbtg/OtppHHmMlCGDUUna2YRpIuT8rxh0PBFpVXLVDv
iS2Aelet8u5fa9IAjbkU+BQVNdnARqN7csiRv8lVK83Qlz6cJmTM386DGXHKTubU
1XupGc1V3sjs0l44U+VcT4wt/lAjNvxm5suOpDkZALeVAjmRCw7+OC7RHQWa9k0+
  bw8HHa8sHo9gOeL6NlMTOdReJivbPagUvTLrGAMoUgRx5aszPeE4uwc2hGKceeoW
MPRfwCvocWvk+QIDAQABo1MwUTAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBTA
ephojYn7qwVkDBF9qn1luMrMTjAfBgNVHSMEGDAWgBTAephojYn7qwVkDBF9qn1l
uMrMTjANBgkqhkiG9w0BAQUFAAOCAQEANeMpauUvXVSOKVCUn5kaFOSPeCpilKIn
Z57QzxpeR+nBsqTP3UEaBU6bS+5Kb1VSsyShNwrrZHYqLizz/Tt1kL/6cdjHPTfS
tQWVYrmm3ok9Nns4d0iXrKYgjy6myQzCsplFAMfOEVEiIuCl6rYVSAlk6l5PdPcF
PseKUgzbFbS9bZvlxrFUaKnjaZC2mqUPuLk/IH2uSrW4nOQdtqvmlKXBx4Ot2/Un
hw4EbNX/3aBd7YdStysVAq45pmp06drE57xNNB6pXE0zX5IJL4hmXXeXxx12E6nV
5fEWCRE11azbJHFwLJhWC9kXtNHjUStedejV0NxPNO3CBWaAocvmMw==
-----END CERTIFICATE-----
EOM

hosts.each do |host|
  run_puppet_install_helper
  install_cert_on_windows(host, 'geotrustglobal', GEOTRUST_GLOBAL_CA)
  # Install module dependencies
  on host, puppet('module', 'install', 'puppetlabs-stdlib')
  on host, puppet('module', 'install', 'puppetlabs-dsc')
  # on host, powershell('Invoke-RestMethod -Method Get -Uri "https://github.com/git-for-windows/git/releases/download/v2.14.1.windows.1/Git-2.14.1-64-bit.exe" -OutFile C:\GitInstall.exe')
  on host, puppet('module', 'install', 'chocolatey-chocolatey')
  MANIFEST = <<-MANIFEST
  include chocolatey
  
  package { 'git':
    ensure   => 'installed',
    provider => 'chocolatey',
  }
MANIFEST
  apply_manifest(MANIFEST, :catch_failures => true)
  execute_powershell_script_on(host, "& 'C:/Program Files/Git/cmd/git.exe' clone https://github.com/tragiccode/tragiccode-ravendb #{host['distmoduledir']}\\ravendb")
  RAVENDB_INSTALL = <<-MANIFEST
    class { 'ravendb':
        package_ensure                         => 'present',
        include_management_tools               => false,
        ravendb_service_name                   => 'RavenDB',
        ravendb_port                           => 8080,
        ravendb_install_log_absolute_path      => 'C:\\RavenDB.install.log',
        ravendb_database_directory             => 'C:\\RavenDB\\Databases',
        ravendb_filesystems_database_directory => 'C:\\RavenDB\\FileSystems',
    }
  MANIFEST
  apply_manifest(RAVENDB_INSTALL, :catch_failures => true)
end

RSpec.configure do |c|
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  c.formatter = :documentation

  c.before :suite do
    # clone_git_repo_on(master, 'C:\\test', extract_repo_info_from(pcp_broker_url))
  end
end