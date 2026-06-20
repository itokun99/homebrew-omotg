class Omotg < Formula
  desc "Telegram ↔ OpenCode bridge with MCP SSE server"
  homepage "https://github.com/itokun99/omotg"
  url "https://github.com/itokun99/omotg/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0019dfc4b32d63c1392aa264aed2253c1e0c2fb09216f8e2cc269bbfb8bb49b5"
  license "MIT"

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
