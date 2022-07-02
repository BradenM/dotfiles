#!/usr/bin/env zsh


#This creates an archive that does the following:

#rsync (Everyone seems to like -z, but it is much slower for me)

#    a: archive mode - rescursive, preserves owner, preserves permissions, preserves modification times, preserves group, copies symlinks as symlinks, preserves device files.
#    H: preserves hard-links
#    A: preserves ACLs
#    X: preserves extended attributes
#    x: don't cross file-system boundaries
#    v: increase verbosity
#    --numeric-ds: don't map uid/gid values by user/group name
#    --delete: delete extraneous files from dest dirs (differential clean-up during sync)
#    --progress: show progress during transfer

#ssh

#    T: turn off pseudo-tty to decrease cpu load on destination.
#    c arcfour: use the weakest but fastest SSH encryption. Must specify "Ciphers arcfour" in sshd_config on destination.
#    o Compression=no: Turn off SSH compression.
#    x: turn off X forwarding if it is on by default.


set -o pipefail
set -x


CHUNK_DIR=$(mktemp --directory)
export RSYNC_ARGS='-aHAXxv --exclude=node_modules --numeric-ids --progress -e'
#export RSYNC_FROM_ARGS='-aHAXxv --files-from {} --exclude=node_modules --numeric-ids --progress -e'
export SSH_ARGS="-T -c aes128-ctr -o Compression=no -x"

create_chunks() {
    list="${CHUNK_DIR}/all"
    sudo rsync --dry-run -aHAXxvr --exclude=node_modules --numeric-ids --progress -e 'ssh -T -c aes128-ctr -o Compression=no -x' $1 $2 | tee "$list"
    split -l 3000 "$list" "${CHUNK_DIR}/transfer."
}


export SRC="$1"
export DEST="$2"

printf "Chunking file list from (%s).\n" "$SRC"
sleep 1
create_chunks "$SRC" "$DEST"

printf "Updating (%s) from (%s).\n" "$DEST" "$SRC"
sleep 2

/usr/bin/ls "${CHUNK_DIR}"/transfer.* | parallel --line-buffer --verbose -j 16 rsync --files-from={} -aHAXxvr --exclude=node_modules --numeric-ids --progress -e \'ssh -T -c aes128-ctr -o Compression=no -x\' $SRC $DEST
