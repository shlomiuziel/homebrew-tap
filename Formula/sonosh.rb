class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/tags/v0.3.2-sonosh.1.tar.gz"
  sha256 "3bd7c05d3f599bbc9f7f2d36eed418acfe7db2ade1b853a4833109991ade55c3"
  version "0.3.2-sonosh.1"
  head "https://github.com/shlomiuziel/sonosh.git", branch: "main"

  depends_on "go" => :build

  def install
    sonosh_bin = libexec/"sonosh"
    system "go", "build", "-o", sonosh_bin, "./cmd/sonosh"

    if OS.mac?
      helper_path = buildpath/"helpers/macos/sonosh-helper"
      system "swift", "build", "--package-path", helper_path, "--configuration", "release", "--disable-sandbox"
      libexec.install helper_path/".build/release/sonosh-macos-helper"
    end

    (bin/"sonosh").write <<~EOS
      #!/bin/bash
      HELPER="#{libexec}/sonosh-macos-helper"
      if [ -x "$HELPER" ]; then
        export SONOSH_MAC_HELPER="$HELPER"
      fi
      exec "#{sonosh_bin}" "$@"
    EOS
    chmod 0755, bin/"sonosh"
  end
end
