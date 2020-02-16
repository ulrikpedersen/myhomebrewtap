class EpicsBase < Formula
  desc "a distributed soft real-time control systems for scientific instruments such as a particle accelerators, telescopes and other large scientific experiments"
  homepage "https://epics.anl.gov"
  url "https://github.com/epics-base/epics-base/archive/R7.0.3.1.tar.gz"
  version "7.0.3.1"
  sha256 "33521511226eead16cb06075cd14336d6715cf8e1b899a11ec70f81f7c7c48b6"

  depends_on "readline"
  depends_on "re2c"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV['EPICS_BASE'] = "#{prefix}"
    ENV['EPICS_HOST_ARCH'] = "darwin-x86"
    inreplace "configure/CONFIG_SITE", /.*INSTALL_LOCATION=.*/, "INSTALL_LOCATION=#{prefix}"
    system "make"
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    # Run the test with `brew test epics-base`. 
    ENV['EPICS_BASE'] = "#{prefix}"
    ENV['EPICS_HOST_ARCH'] = "darwin-x86"
    system "make", "-C", "#{buildpath}", "tapfiles"
    system "make", "-C", "#{buildpath}", "-s", "test-results"
  end
end
