{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "mpdecimal";
  version = "4.0.0";
  outputs = [
    "out"
    "cxx"
    "doc"
    "dev"
  ];

  src = fetchurl {
    url = "https://www.bytereef.org/software/mpdecimal/releases/mpdecimal-${version}.tar.gz";
    hash = "sha256-lCRFwyRbInMP1Bpnp8XCMdEcsbmTa5wPdjNPt9C0Row=";
  };

  nativeBuildInputs = [ autoreconfHook ];

  configureFlags = [ "LD=${stdenv.cc.targetPrefix}cc" ];

  postPatch = ''
    # Use absolute library install names on Darwin.
    substituteInPlace configure.ac \
      --replace-fail '-install_name @rpath/' "-install_name $out/lib/"
  '';

  postInstall = ''
    mkdir -p $cxx/lib
    mv $out/lib/*c++* $cxx/lib

    mkdir -p $dev/nix-support
    echo -n $cxx >> $dev/nix-support/propagated-build-inputs
  '';

  meta = {
    description = "Library for arbitrary precision decimal floating point arithmetic";

    longDescription = ''
      libmpdec is a fast C/C++ library for correctly-rounded arbitrary
      precision decimal floating point arithmetic.  It is a complete
      implementation of Mike Cowlishaw/IBM's General Decimal Arithmetic
      Specification. The full specification is available here:

      http://speleotrove.com/decimal/

      libmpdec will - with minor restrictions - also conform to the IEEE
      754-2008 Standard for Floating-Point Arithmetic, provided that the
      appropriate context parameters are set.

      libmpdec++ is a complete implementation of the General Decimal Arithmetic
      Specification.  libmpdec++ is mostly a header library around libmpdec's C
      functions.
    '';

    homepage = "https://www.bytereef.org/mpdecimal/index.html";

    downloadPage = "https://www.bytereef.org/mpdecimal/download.html";

    changelog = "https://www.bytereef.org/mpdecimal/changelog.html";

    license = lib.licenses.bsd2;

    maintainers = with lib.maintainers; [ kaction ];

    platforms = lib.platforms.unix ++ lib.platforms.windows;
  };
}
