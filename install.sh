#!/bin/bash
LOCAL_INCLUDE="$HOME/.local/include"
LOCAL_LIB="$HOME/.local/lib"
PRINT_PROC="print_proc.o"
PRINT_PROC64="print_proc64.o"
PRINT_PROCS_H="print_procs.asmh"

MSG0="Print procs foi instalado com sucesso nos diretórios $LOCAL_INCLUDE e $LOCAL_LIB, onde o primeiro contêm o arquivo de header para declaração dos procedimentos e o segundo os objetos binários.  Para desinstalar, execute o comando 'make uninstall' ou 'bash uninstall.sh'.
"

MSG_ERR="A biblioteca não pode ser instalada nos diretórios do teu usuarios. Verifique se ela foi compilada corretamente e se os arquivos print_proc.o e print_proc64.o estão presentes em ./build. Se sim, poderás instalar manualmente."

#Cria diretorios para conter os arquivos caso não existam
if ! (test -d "$LOCAL_INCLUDE") then
  mkdir "$LOCAL_INCLUDE"
fi

if ! ( test -d "$LOCAL_LIB") then
  mkdir "$LOCAL_LIB"  
fi

#Copia os arquivos para estes diretorios
if
  (cp "$PWD/build/$PRINT_PROC" "$LOCAL_LIB/$PRINT_PROC") &&
  (cp "$PWD/build/$PRINT_PROC64" "$LOCAL_LIB/$PRINT_PROC64") &&
  (cp "$PWD/src/asm/$PRINT_PROCS_H" "$LOCAL_INCLUDE/$PRINT_PROCS_H")
then
  echo "$MSG0"
  echo "$MSG1"
else
  echo "$MSG_ERR"
fi
