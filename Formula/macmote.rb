class Macmote < Formula
  desc "Phone remote for your Mac, with Face ID approval for sudo"
  homepage "https://github.com/pysunn14/macmote"
  url "https://github.com/pysunn14/macmote/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "f659a8c247a32599fb4d7954e7cc540efefba29c77922066413e30735d5d2c2a"
  license "MIT"
  head "https://github.com/pysunn14/macmote.git", branch: "main"

  depends_on :macos

  def install
    # Builds the Swift helpers (macctl, webpush, the PAM module, the enrollment tool) with the
    # Command Line Tools' swiftc; nothing is downloaded. The tree is kept whole under libexec
    # because the server reads web/ and the installer copies build/ from there.
    system "scripts/build.sh"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/macmote"
  end

  def caveats
    <<~EOS
      Finish on this Mac with:
        macmote setup
      It installs a launchd user agent, proposes the Tailscale Serve rules, installs the
      sudo hook (asks for sudo) and prints a QR code to pair your iPhone.
      Remove the sudo hook before uninstalling: macmote sudo remove
    EOS
  end

  test do
    assert_match "macmote #{version}", shell_output("#{bin}/macmote --version")
    assert_path_exists libexec/"build/pam_macmote.so"
    assert_match "volume", shell_output("#{bin}/macmote actions")
  end
end
