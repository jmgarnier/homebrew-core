class Privoxy < Formula
  desc "Advanced filtering web proxy"
  homepage "https://www.privoxy.org/"
  url "https://downloads.sourceforge.net/project/ijbswa/Sources/3.0.26%20%28stable%29/privoxy-3.0.26-stable-src.tar.gz"
  sha256 "57e415b43ee5dfdca74685cc034053eaae962952fdabd086171551a86abf9cd8"

  bottle do
    cellar :any
    rebuild 1
    sha256 "bd606ba22bca049b7f0457cdfa846aefa09eaf2c9d1e18ff3584254e1fc05048" => :sierra
    sha256 "4aa50d19fa164c7bb5b6a14f5ef562fb9b40acebe8575cd5af4dffac78fa3400" => :el_capitan
    sha256 "8a0e661df5d221ae65b6367791a923d1f2b769b0206b3fb50c1e6a84f2830d7b" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pcre"

  def install
    # Find Homebrew's libpcre
    ENV.append "LDFLAGS", "-L#{HOMEBREW_PREFIX}/lib"

    # No configure script is shipped with the source
    system "autoreconf", "-i"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}/privoxy",
                          "--localstatedir=#{var}"
    system "make"
    system "make", "install"
  end

  plist_options :manual => "privoxy #{HOMEBREW_PREFIX}/etc/privoxy/config"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>WorkingDirectory</key>
      <string>#{var}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{sbin}/privoxy</string>
        <string>--no-daemon</string>
        <string>#{etc}/privoxy/config</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/privoxy/logfile</string>
    </dict>
    </plist>
    EOS
  end
end
