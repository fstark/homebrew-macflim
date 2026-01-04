class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  url "https://github.com/fstark/macflim/releases/download/v2.0.17/macflim-v2.0.17.tar.gz"
  sha256 "556f5b7adaaaac5e277236e3273de15bbf597e9d9d1066aa3a2d6b30dbb320da"
  license "MIT"

  depends_on "gcc@14" => :build
  depends_on "ffmpeg"
  depends_on "imagemagick"
  depends_on "yt-dlp"

  def install
    # Build with g++-14
    cd "src" do
      system "make", "clean"
      system "make", "release", "CPP=g++-14"
    end

    # Install the binary
    bin.install "flimmaker"
  end

  test do
    system "#{bin}/flimmaker", "--help"
  end
end
