dnl $Id$
dnl config.m4 for extension testext

dnl Comments in this file start with the string 'dnl'.
dnl Remove where necessary. This file will not work
dnl without editing.

dnl If your extension references something external, use with:

PHP_ARG_WITH(testext, for testext support,
dnl Make sure that the comment is aligned:
[  --with-testext             Include testext support])

dnl Otherwise use enable:

dnl PHP_ARG_ENABLE(testext, whether to enable testext support,
dnl Make sure that the comment is aligned:
dnl [  --enable-testext           Enable testext support])

if test "$PHP_TESTEXT" != "no"; then
  dnl Write more examples of tests here...

  dnl # --with-testext -> check with-path
  dnl SEARCH_PATH="/usr/local /usr"     # you might want to change this
  dnl SEARCH_FOR="/include/testext.h"  # you most likely want to change this
  dnl if test -r $PHP_TESTEXT/$SEARCH_FOR; then # path given as parameter
  dnl   TESTEXT_DIR=$PHP_TESTEXT
  dnl else # search default path list
  dnl   AC_MSG_CHECKING([for testext files in default path])
  dnl   for i in $SEARCH_PATH ; do
  dnl     if test -r $i/$SEARCH_FOR; then
  dnl       TESTEXT_DIR=$i
  dnl       AC_MSG_RESULT(found in $i)
  dnl     fi
  dnl   done
  dnl fi
  dnl
  dnl if test -z "$TESTEXT_DIR"; then
  dnl   AC_MSG_RESULT([not found])
  dnl   AC_MSG_ERROR([Please reinstall the testext distribution])
  dnl fi

  dnl # --with-testext -> add include path
  dnl PHP_ADD_INCLUDE($TESTEXT_DIR/include)

  dnl # --with-testext -> check for lib and symbol presence
  dnl LIBNAME=testext # you may want to change this
  dnl LIBSYMBOL=testext # you most likely want to change this 

  dnl PHP_CHECK_LIBRARY($LIBNAME,$LIBSYMBOL,
  dnl [
  dnl   PHP_ADD_LIBRARY_WITH_PATH($LIBNAME, $TESTEXT_DIR/$PHP_LIBDIR, TESTEXT_SHARED_LIBADD)
  dnl   AC_DEFINE(HAVE_TESTEXTLIB,1,[ ])
  dnl ],[
  dnl   AC_MSG_ERROR([wrong testext lib version or lib not found])
  dnl ],[
  dnl   -L$TESTEXT_DIR/$PHP_LIBDIR -lm
  dnl ])
  dnl
  dnl PHP_SUBST(TESTEXT_SHARED_LIBADD)

  PHP_NEW_EXTENSION(testext, testext.c, $ext_shared)
fi
