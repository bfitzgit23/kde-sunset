inherit cmake

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install

kde4-meta_src_unpack()   { default; }
kde4-meta_src_prepare()  { cmake_src_prepare; }
kde4-meta_src_configure(){ cmake_src_configure; }
kde4-meta_src_compile()  { cmake_src_compile; }
kde4-meta_src_install()  { cmake_src_install; }
