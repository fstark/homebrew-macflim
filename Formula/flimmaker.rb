class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/fstark/macflim/releases/download/v0.1.0/flimmaker-arm64-macos.tar.gz"
      sha256 "PLACEHOLDER_ARM64_SHA256"
    elsif Hardware::CPU.intel?
      url "https://github.com/fstark/macflim/releases/download/v0.1.0/flimmaker-x86_64-macos.tar.gz"
      sha256 "PLACEHOLDER_X86_64_SHA256"
    end
  end

  def install
    # Install everything to libexec to keep libraries bundled
    libexec.install "bin/flimmaker", "bin/lib"
    
    # Create wrapper script in bin that calls the binary in libexec
    # The binary's @rpath is set to @executable_path/lib, so it will find libraries correctly
    (bin/"flimmaker").write_env_script libexec/"flimmaker", {}
  end

  test do
    system "#{bin}/flimmaker", "--help"
  end
end
