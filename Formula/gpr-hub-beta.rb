class GprHubBeta < Formula
  desc "GPR Image Reader and AI Analyzer (Beta)"
  homepage "https://github.com/Codemaster-AR/gpr-hub-cli-beta"
  url "https://github.com/Codemaster-AR/GPR-Hub-CLI-Beta/archive/refs/tags/v6.0.0-beta.tar.gz"
  sha256 "9db928f554471c3c00fdabd0d84c571121d027863f5659939a75670579d93344"
  license "MIT"

  # Core Dependencies
  depends_on "python@3.12"
  depends_on "libffi"
  depends_on "openssl@3"
  
  # Build-only Dependencies (The "Insurance Policy")
  # These are only used if a pre-compiled version isn't found
  depends_on "pkg-config" => :build
  depends_on "rust" => :build 

  def install
    # 1. Create a clean virtualenv
    system "python3.12", "-m", "venv", libexec
    venv_pip = libexec/"bin/pip"

    # 2. Setup environment for "worst-case scenario" (Source Build)
    # If Pip has to compile cryptography, these lines tell it where to look.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["LDFLAGS"] = "-L#{Formula["openssl@3"].opt_lib} -L#{Formula["libffi"].opt_lib}"
    ENV["CPPFLAGS"] = "-I#{Formula["openssl@3"].opt_include} -I#{Formula["libffi"].opt_include}"

    # 3. Upgrade core tools
    system venv_pip, "install", "--upgrade", "pip", "setuptools", "wheel"

    # 4. The "Smart Install"
    # --prefer-binary tells Pip: "Use a wheel if it exists (99% of users)."
    # If no wheel exists, it will use the Rust/OpenSSL/Libffi we provided to build it.
    system venv_pip, "install", "--prefer-binary", "requests", "cryptography"

    # 5. Install your actual package
    system venv_pip, "install", buildpath

    # 6. Final Symlink
    bin.install_symlink libexec/"bin/gpr-hub" => "gpr-hub-beta"
  end

  test do
    system "#{bin}/gpr-hub-beta", "--version"
  end
end
