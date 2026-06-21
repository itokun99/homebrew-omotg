class Omotg < Formula
  desc "Telegram ↔ OpenCode bridge with MCP SSE server"
  homepage "https://github.com/itokun99/omotg"
  url "https://github.com/itokun99/omotg/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "6d66781b994eb977c6bf2d9c9da92dc320363a0e2c8fde7897c8d0a1a4b12ac1"
  license "CC-BY-NC-4.0"

  depends_on "go" => :build

  def install
    system "go", "build", "-o", "omotg", "."
    bin.install "omotg"
    (etc/"omotg").install "env.template"
  end

  def caveats
    <<~EOS
      OMOTG installed! Next steps:

        1. Create config directory:
           mkdir -p ~/.config/omotg

        2. Copy and edit env template:
           cp #{etc}/omotg/env.template ~/.config/omotg/env

        3. Fill in ~/.config/omotg/env with:
           - TELEGRAM_BOT_TOKEN (from @BotFather)
           - TELEGRAM_WEBHOOK_URL (https://your.domain:8443/webhook)
           - TELEGRAM_SECRET_TOKEN (random string)
           - OPENCODE_SERVER_PASSWORD (any string)

        4. Generate a self-signed TLS cert:
           openssl req -x509 -nodes -days 365 -newkey rsa:2048 \\
             -keyout ~/.config/omotg/webhook.key \\
             -out ~/.config/omotg/webhook.crt \\
             -subj "/CN=your.domain.com" \\
             -addext "subjectAltName=DNS:your.domain.com"

        5. Set up systemd user services:
           See the full README at #{share}/doc/omotg/README.md
           or https://github.com/itokun99/omotg

      Webhook endpoint: https://your.domain:8443/webhook
      MCP SSE endpoint: http://127.0.0.1:9090/mcp/sse
    EOS
  end

  test do
    assert_match "TELEGRAM_BOT_TOKEN", shell_output("cat #{etc}/omotg/env.template")
  end
end
