#!/usr/bin/env python
import subprocess as sp
import os
import sys
import shlex
from typing import List
from pathlib import Path

home = Path.home()

def run_zathura(pdf: str):
    cmd = f"zathura {pdf}"
    sp.Popen(shlex.split(cmd), start_new_session=True, stdout=sp.DEVNULL, stderr=sp.STDOUT)

def get_all_available_pdfs(paths: List[str]) -> List[str]:
    # Iterate list of paths and find all PDF files
    pdfs = []
    for path in paths:
        cmd = f"find {path} -name '*.pdf'"
        pdfs += sp.check_output(shlex.split(cmd)).decode().splitlines()
    return pdfs

def pick_pdf(pdfs: List[str]) -> str:
    fzf = sp.Popen(["fzf"], stdout=sp.PIPE, stdin=sp.PIPE, text=True)
    pdf = fzf.communicate("\n".join(pdfs))[0]
    if fzf.returncode == 0:
        return pdf
    else:
        return ""

def get_all_search_paths() -> List[str]:
    search_paths = []
    try:
        with open(home / ".local" / "pdf_paths") as f:
            temp = f.read().splitlines()
        search_paths = [os.path.expandvars(os.path.expanduser(x)) for x in temp]
    except Exception as ex:
        print("Please put paths to search for pdfs into '~/.local/pdf_paths'")
        sys.exit(-1)
    return search_paths

paths = get_all_search_paths()
pdfs = get_all_available_pdfs(paths)
pdf = pick_pdf(pdfs)
if pdf and pdf != "":
    run_zathura(pdf)
