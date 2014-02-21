require 'puppet/provider/package'

Puppet::Type.type(:package).provide(:tap, :parent => Puppet::Provider::Package) do
  CUSTOM_ENVIRONMENT = { "HOMEBREW_CACHE" => "/Library/Caches/Homebrew", "HOMEBREW_LOGS" => "/Library/Logs/Homebrew/" }
  desc "Homebrew repository management on OS X"

  confine  :operatingsystem => :darwin

  has_feature :installable, :install_options
  has_feature :uninstallable

  commands :id   => "/usr/bin/id"
  commands :stat => "/usr/bin/stat"
  commands :sudo => "/usr/bin/sudo"
  commands :brew => "/usr/local/bin/brew"

  def self.execute(cmd)
    owner = super([command(:stat), '-nf', '%Uu', command(:brew)]).to_i
    Puppet.debug "command owner is: #{owner}"
    if super([command(:id), '-u']).to_i.zero?
      Puppet.debug "running command in sudo environment as current user is root"
      super(cmd, :uid => owner, :failonfail => true, :combine => true, :custom_environment => CUSTOM_ENVIRONMENT)
    else
      Puppet.debug "running command with current (non-root) user"
      super(cmd, :failonfail => true, :combine => true, :custom_environment => CUSTOM_ENVIRONMENT)
    end
  end

  def execute(*args)
    self.class.execute(*args)
  end

  # Install packages, known as formulas, using brew.
  def install
    Puppet.notice "Tapping repository #{@resource[:name]}"
    output = execute([command(:brew), :tap, @resource[:name]])

    # Fail hard if there is no tap available.
    if output =~ /Error: Invalid tap name/
      raise Puppet::ExecutionFailure, "Could not find package #{@resource[:name]}"
    end
  end

  def uninstall
    Puppet.notice "Untapping repository #{@resource[:name]}"
    execute([command(:brew), :untap, @resource[:name]])
  end

  def self.instances
    Puppet.debug "Listing currently tapped repositories"
    taps = []
    begin
      execpipe([command(:brew), :tap]) do |process|
        process.each_line do |line|
          line.chomp!
          next if line.empty?
          Puppet.debug "  Repository #{line} is currently tapped."
          packages << new({ :name => line, :ensure => 'present', :provider => 'tap' })
        end
      end
      taps
    rescue Puppet::ExecutionFailure
      Puppet.err "Instances failed: #{$!}"
      nil
    end
  end
end
