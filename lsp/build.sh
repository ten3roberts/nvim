{
  cd lua-language-server
  git submodule update --init --recursive

  echo "Here"
  cd 3rd/luamake
  ./compile/install.sh
  cd ../..
  ./3rd/luamake/luamake rebuild
}
