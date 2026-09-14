class Console2svg < Formula
  desc "Convert terminal output to SVG images"
  homepage "https://github.com/arika0093/console2svg"
  version "0.9.3"
  license "Apache-2.0"

  depends_on :macos

  on_arm do
    url "https://github.com/arika0093/console2svg/releases/download/v0.9.3/console2svg-osx-arm64.tar.gz"
    sha256 "e56d5e86e2d66c19264719eb845027bfa06d84973bdfacac1e4569d2f50146ff"
  end

  on_intel do
    url "https://github.com/arika0093/console2svg/releases/download/v0.9.3/console2svg-osx-x64.tar.gz"
    sha256 "bbb2045f42bd3a83e68b7db233e65abf751ef932dd6cb3fa6a3061ba27c64b66"
  end

  def install
    libexec.install "console2svg", "libconsole2svg_resvg.dylib"

    (bin/"console2svg").write <<~SH
      #!/bin/bash
      if [[ "${1:-}" == "update" ]]; then
        for arg in "$@"; do
          if [[ "$arg" == "--check" || "$arg" == "--force" ]]; then
            exec "#{libexec}/console2svg" "$@"
          fi
        done
        echo "This installation is managed by Homebrew." >&2
        echo "Use: brew upgrade arika0093/console2svg/console2svg" >&2
        exit 1
      fi
      exec "#{libexec}/console2svg" "$@"
    SH
    chmod 0755, bin/"console2svg"
  end

  test do
    output = testpath/"output.svg"
    system bin/"console2svg", "capture", "-o", output, "--", "/usr/bin/printf", "hello"
    assert_path_exists output
    assert_match "hello", output.read
  end
end
