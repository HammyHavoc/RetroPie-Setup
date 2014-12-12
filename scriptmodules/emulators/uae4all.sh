rp_module_id="uae4all"
rp_module_desc="Amiga emulator UAE4All"
rp_module_menus="2+"

function depends_uae4all() {
    rps_checkNeededPackages libsdl1.2-dev libsdl-mixer1.2-dev libasound2-dev
}

function sources_uae4all() {
    wget -O- -q http://downloads.petrockblock.com/retropiearchives/uae4rpi.tar.bz2 | tar -xvj --strip-components=1
    sed -i "s/-lstdc++$/-lstdc++ -lm -lz/" Makefile
}

function build_uae4all() {
    touch /opt/vc/include/interface/vmcs_host/vchost_config.h
    make clean
    make
    md_ret_require="$md_build/uae4all"
}

function install_uae4all() {
    md_ret_files=(
        'COPYING'
        'docs'
        'uae4all'
    )
}

function configure_uae4all() {
    mkdir -p "$romdir/amiga"

    cat > "$md_inst/startAmigaDisk.sh" << _EOF_
#!/bin/bash
pushd "$md_inst"
if [[ -f "df0.adf" ]]; then
     rm df0.adf
 fi
ln -s "$romdir/amiga/$1" "df0.adf"
./uae4all    
popd
_EOF_
    chmod +x "$md_inst/startAmigaDisk.sh"

    chown -R $user:$user "$md_inst"

    setESSystem "Amiga" "amiga" "~/RetroPie/roms/amiga" ".adf .ADF" "$md_inst/startAmigaDisk.sh %ROM%" "amiga" "amiga"
}
