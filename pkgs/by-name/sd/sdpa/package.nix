{
  lib,
  stdenv,
  fetchurl,
  gfortran,
  blas,
  lapack,
  mumps,
}:

stdenv.mkDerivation (finalAttrs: rec {
  pname = "sdpa";
  version = "7.3.18";

  src = fetchurl {
    url = "mirror://sourceforge/${pname}/${pname}_${version}.tar.gz";
    hash = "sha256-b+DLgc5zE0UYB4fJDj/92hkYTsZ7x7nQ+A2HxCDLVkc=";
  };

  nativeBuildInputs = [
    gfortran
  ];

  buildInputs = [
    mumps
    blas
    lapack
  ];

  configureFlags = [
    # The original configure script will attempt to pull the MUMPS
    # source code via wget, and to build and install it manually.
    # We override the relevant variables ourselves to avoid that.
    # See <src>/configure.ac for more info.
    "MUMPS_INCLUDE=\"-I${mumps}/include\""
    "MUMPS_LIBS=-ldmumps"
  ];

  meta = {
    # descriptions extracted from website
    description = "High-performance package for SemiDefinite Programs (base version)";
    longDescription = ''
      SDPA (SemiDefinite Programming Algorithm) is one of the most efficient and stable software packages for solving SDPs based on the primal-dual interior-point method. It fully exploits the sparsity of given problems.
    '';

    homepage = "https://sdpa.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ lcwllmr ];
    mainProgram = "sdpa";
    meta.platforms = lib.platforms.linux; # TODO: test on others
  };
})
