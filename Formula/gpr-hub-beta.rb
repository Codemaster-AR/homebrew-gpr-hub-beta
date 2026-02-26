class GprHubBeta < Formula
  desc "GPR Image Reader and AI Analyzer (Beta)"
  homepage "https://github.com/Codemaster-AR/gpr-hub-cli-beta"
  url "https://github.com/Codemaster-AR/GPR-Hub-CLI-Beta/archive/refs/tags/v6.0.0-beta.tar.gz"
  sha256 "9db928f554471c3c00fdabd0d84c571121d027863f5659939a75670579d93344"
  license "MIT"

  depends_on "python@3.12"
  depends_on "libffi"
  depends_on "openssl@3"
  depends_on "pkg-config" => :build
  depends_on "rust" => :build 

  # This stops Homebrew from trying to fix library links inside the cellar,
  # which prevents the "Failed to fix install linkage" error.
  def self.post_install_fixup(keg)
    return
  end

  def install
    # 1. Setup the virtual environment
    system "python3.12", "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"
    venv_python = libexec/"bin/python"

    # 2. Install dependencies with binary preference
    # This avoids the 'maturin' crash for 99% of users.
    system venv_pip, "install", "--upgrade", "pip", "setuptools", "wheel"
    system venv_pip, "install", "--prefer-binary", 
           "matplotlib", "numpy", "google-genai", "colorama", 
           "cinetext", "keyboard", "KeyboardGate", "Pillow", 
           "rich", "requests", "cryptography"

    # 3. Install the source code from the current build directory
    system venv_pip, "install", "."

    # 4. Create a custom executable wrapper
    # This manually points to the 'main' function inside 'gpr_hub/main.py'
    (bin/"gpr-hub-beta").write <<~EOS
      #!/bin/bash
      export PATH="#{libexec}/bin:$PATH"
      exec "#{venv_python}" -c "from gpr_hub.main import main; main()" "$@"
    EOS
    
    # Make the wrapper executable
    chmod 0755, bin/"gpr-hub-beta"
  end

  test do
    # Simple check to see if the command responds
    system "#{bin}/gpr-hub-beta", "--version"
  end
end
