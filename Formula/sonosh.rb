class Sonosh < Formula
  desc "Sonos TUI and CLI"
  homepage "https://github.com/shlomiuziel/sonosh"
  url "https://github.com/shlomiuziel/sonosh/archive/refs/heads/main.tar.gz"
  sha256 "173730a59a5a23e736b625f6679a306415a9fb7a0cf1f9d6fee5e4f127a021b5"
  version "main"
  head "https://github.com/shlomiuziel/sonosh.git", branch: "main"

  depends_on "go" => :build

  def install
    sonosh_bin = libexec/"sonosh"
    system "go", "build", "-o", sonosh_bin, "./cmd/sonosh"

    if OS.mac?
      helper_path = buildpath/"helpers/macos/sonosh-helper"
      system "swift", "build", "--package-path", helper_path, "--configuration", "release"
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
