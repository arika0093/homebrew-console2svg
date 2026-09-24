class Console2svg < Formula
  desc "Convert terminal output to SVG images"
  homepage "https://github.com/arika0093/console2svg"
  version "0.10.1"
  license "Apache-2.0"

  on_macos do
    on_arm do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.1/console2svg-osx-arm64.tar.gz"
      sha256 "914c14ed6add31e28e0231d8d56f8caac2396e36b37f98ead6438c2410f7712e"
    end

    on_intel do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.1/console2svg-osx-x64.tar.gz"
      sha256 "6df65344e9e18e6b3e02415f128964178966f9c5d421e35bb07c33ed1e8ab3df"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.1/console2svg-linux-arm64.tar.gz"
      sha256 "cb8a8c2fb3ee6dc8486ccd9be7a7c674620bcbccc16785b612ce8555ea2d45fe"
    end

    on_intel do
      url "https://github.com/arika0093/console2svg/releases/download/v0.10.1/console2svg-linux-x64.tar.gz"
      sha256 "4977d023216457979e538b60c2e50eda4372eb6a6743d76db422506486849a24"
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
