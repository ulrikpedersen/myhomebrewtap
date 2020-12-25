class Pcas < Formula
  desc "Portable Channel Access Server (PCAS)"
  homepage "https://github.com/epics-modules/pcas"
  url "https://github.com/epics-modules/pcas/archive/v4.13.2.tar.gz"
  # version "4.13.2"
  sha256 "7ff1dd052d6df97141c68fb4fc26f8a4337c7d133114012295bb5c2bfa8d2a59"

  keg_only "the EPICS build system does not lend itself particularly well to installing in a central system location"

  depends_on "epics-base"

  def install
    epics_base = Formula["epics-base"].epics_base
    epics_host_arch = Formula["epics-base"].epics_host_arch
    ENV["EPICS_BASE"] = epics_base.to_s
    ENV["EPICS_HOST_ARCH"] = epics_host_arch.to_s

    # EPICS 'configure' step is to edit files in the configure/ dir to point to dependencies, etc.
    inreplace "configure/CONFIG_SITE", /^#?\s*INSTALL_LOCATION\s*=.*$/, "INSTALL_LOCATION=#{prefix}/top"
    inreplace "configure/RELEASE", /^EPICS_BASE\s*=.*/, "EPICS_BASE=#{epics_base}"
    system "make"
  end

  test do
    ENV["EPICS_BASE"] = Formula["epics-base"].epics_base
    ENV["EPICS_HOST_ARCH"] = Formula["epics-base"].epics_host_arch
    # TODO: what can we do for testing pcas here?
  end
end
