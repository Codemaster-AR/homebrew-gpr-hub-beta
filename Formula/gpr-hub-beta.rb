class GprHubBeta < Formula
  include Language::Python::Virtualenv

  desc "GPR Image Reader and AI Analyzer (Beta)"
  homepage "https://github.com/Codemaster-AR/gpr-hub-cli-beta"
  url "https://github.com/Codemaster-AR/GPR-Hub-CLI-Beta/archive/refs/tags/v6.0.0-beta.tar.gz"
  sha256 "9db928f554471c3c00fdabd0d84c571121d027863f5659939a75670579d93344"
  license "MIT"

  # Core Dependencies
  depends_on "python@3.12"
  depends_on "libffi"
  depends_on "openssl@3"
  
  # Build-only dependencies (Needed for Linux/WSL source builds)
  depends_on "pkg-config" => :build

  def install
    # 1. Create the virtualenv using the standard helper
    venv = virtualenv_create(libexec, "python3.12")

    # 2. Universal Environment Flags
    # This tells the compiler where OpenSSL and Libffi are on ANY OS (macOS or Linux)
    ENV.append "LDFLAGS", "-L#{Formula["openssl@3"].opt_lib}"
    ENV.append "LDFLAGS", "-L#{Formula["libffi"].opt_lib}"
    ENV.append "CPPFLAGS", "-I#{Formula["openssl@3"].opt_include}"
    ENV.append "CPPFLAGS", "-I#{Formula["libffi"].opt_include}"
    
    # Required for some Linux distributions to link correctly
    ENV["PKG_CONFIG_PATH"] = "#{Formula["openssl@3"].opt_lib}/pkgconfig:#{Formula["libffi"].opt_lib}/pkgconfig"

    # 3. Install dependencies
    # We don't use --only-binary so it stays flexible for WSL/Linux
    venv.pip_install "requests"
    venv.pip_install "cryptography"

    # 4. Install the actual package
    venv.pip_install buildpath

    # 5. Symlink the command
    # Uses '=>' to rename the binary to gpr-hub-beta universally
    bin.install_symlink libexec/"bin/gpr-hub" => "gpr-hub-beta"
  end

  test do
    system "#{bin}/gpr-hub-beta", "--version"
  end
end
