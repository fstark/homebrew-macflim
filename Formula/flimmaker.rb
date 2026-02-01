class Flimmaker < Formula
  desc "Create classic Macintosh FLIM movies from modern video files"
  homepage "https://github.com/fstark/macflim"
  url "https://github.com/fstark/macflim/releases/download/v2.0.19/macflim-v2.0.19.tar.gz"
  sha256 "997bc3cf0f252c4d61351c6cbb8868d13043f32517266af9d085df277f228cdd"
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
