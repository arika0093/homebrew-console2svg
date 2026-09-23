class Console2svg < Formula
  desc "Convert terminal output to SVG images"
  homepage "https://github.com/arika0093/console2svg"
  version "0.10.0"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.0/console2svg-osx-arm64.tar.gz"
      sha256 "5a75f0ee9a9ceb25a2e3e77c468ebf03b2bd18f97f092aa67023ff2927241c8a"
    end

    on_intel do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.0/console2svg-osx-x64.tar.gz"
      sha256 "9fe0820211e1700945e0d02bb25d501fef7c02eccd5fad34ecc73192e5bebf99"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.0/console2svg-linux-arm64.tar.gz"
      sha256 "15f716f53f9f9fefa924065b914f03bdf75d5fbab79887a96f5a35236fd33be2"
    end

    on_intel do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.0/console2svg-linux-x64.tar.gz"
      sha256 "5b1cf28d0a86ad41dedfbc75d8f3cc6b0cfdc55feb8f9e658086a1e8e2d06be0"
    end
  end

  def install
    native_library = OS.mac? ? "libconsole2svg_resvg.dylib" : "libconsole2svg_resvg.so"
    libexec.install "console2svg", native_library

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
