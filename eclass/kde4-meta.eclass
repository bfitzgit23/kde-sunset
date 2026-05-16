inherit cmake kde4-functions

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install

kde4-meta_pkg_setup()    { kde4-base_pkg_setup; }
kde4-meta_pkg_preinst()  { kde4-functions_pkg_preinst; }
kde4-meta_pkg_postinst() { kde4-functions_pkg_postinst; }
kde4-meta_pkg_postrm()   { kde4-functions_pkg_postrm; }
kde4-meta_pkg_prerm()    { kde4-functions_pkg_prerm; }

kde4-meta_src_unpack()   { default; }
kde4-meta_src_prepare()  { cmake_src_prepare; }
kde4-meta_src_configure(){ cmake_src_configure; }
kde4-meta_src_compile()  { cmake_src_compile; }
kde4-meta_src_install()  { cmake_src_install; }
