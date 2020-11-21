class Sscan < Formula
  desc "Contains support for run-time expression evaluation, similar to calcPostfix, in EPICS base, but extended to handle strings, arrays, and additional numeric operations"
  homepage "https://epics.anl.gov/bcda/synApps/sscan/sscan.html"
  url "https://github.com/epics-modules/sscan/archive/R2-11-3.tar.gz"
  version "2.11.3"
  sha256 "dcd883900fbf4b8b46ed03a952e76731b873a96b07d457089cdabbe55b955e65"

  keg_only :provided_by_macos,
    "the EPICS build system does not lend itself particularly well to installing in a central system location"

  depends_on "epics-base"
  depends_on "seq"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    epics_base = Formula["epics-base"].opt_prefix
    ENV["EPICS_BASE"] = epics_base.to_s
    ENV["EPICS_HOST_ARCH"] = "darwin-x86"

    # EPICS 'configure' step is to edit files in the configure/ dir to point to dependencies, etc.
    seq_prefix = Formula["seq"].opt_prefix
    inreplace "configure/RELEASE", /^#?\s*SNCSEQ\s*=.*$/, "SNCSEQ=#{seq_prefix}"
    inreplace "configure/RELEASE", /^SUPPORT=.*$/, "# removed unused SUPPORT macro"
    inreplace "configure/CONFIG_SITE", /^#?\s*INSTALL_LOCATION\s*=.*$/, "INSTALL_LOCATION=#{prefix}"
    inreplace "configure/RELEASE", /^EPICS_BASE\s*=.*/, "EPICS_BASE=#{epics_base}"
    system "make"

    opi = Pathname.new("#{prefix}/sscanApp/op")
    opi.mkpath
    opi.install Dir["sscanApp/op/*"]
  end
end
