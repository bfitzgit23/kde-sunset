qt4_qmake_configure() {
    qmake "$@" || die "qmake failed"
}
EXPORT_FUNCTIONS configure
