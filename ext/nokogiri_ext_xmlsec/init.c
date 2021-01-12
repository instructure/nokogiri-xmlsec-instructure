#include "xmlsecrb.h"
#include "util.h"

#include <xmlsec/dl.h>
#include <xmlsec/errors.h>

#ifndef XMLSEC_NO_XSLT
#include <libxslt/xslt.h>
#include <libxslt/security.h>
#endif /* XMLSEC_NO_XSLT */

EXTENSION_EXPORT
void Init_nokogiri_ext_xmlsec() {
#ifndef XMLSEC_NO_XSLT
    xsltSecurityPrefsPtr xsltSecPrefs = NULL;
#endif /* XMLSEC_NO_XSLT */

  /* xmlsec proper */
  // libxml
  xmlInitParser();
  LIBXML_TEST_VERSION
  xmlLoadExtDtdDefaultValue = XML_DETECT_IDS | XML_COMPLETE_ATTRS;
  // xslt

#ifndef XMLSEC_NO_XSLT
  xmlIndentTreeOutput = 1;

  /* Disable all XSLT options that give filesystem and network access. */
  xsltSecPrefs = xsltNewSecurityPrefs();
  /* xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_READ_FILE,        xsltSecurityForbid); */
  xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_WRITE_FILE,       xsltSecurityForbid);
  xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_CREATE_DIRECTORY, xsltSecurityForbid);
  xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_READ_NETWORK,     xsltSecurityForbid);
  xsltSetSecurityPrefs(xsltSecPrefs,  XSLT_SECPREF_WRITE_NETWORK,    xsltSecurityForbid);
  xsltSetDefaultSecurityPrefs(xsltSecPrefs);
#endif /* XMLSEC_NO_XSLT */

  // xmlsec

  if (xmlSecInit() < 0) {
    rb_raise(rb_eRuntimeError, "xmlsec initialization failed");
    return;
  }
  if (xmlSecCheckVersion() != 1) {
    rb_raise(rb_eRuntimeError, "xmlsec version is not compatible");
    return;
  }
  // load crypto
  #ifdef XMLSEC_CRYPTO_DYNAMIC_LOADING
    if(xmlSecCryptoDLLoadLibrary(BAD_CAST XMLSEC_CRYPTO) < 0) {
      rb_raise(rb_eRuntimeError,
        "Error: unable to load default xmlsec-crypto library. Make sure"
        "that you have it installed and check shared libraries path\n"
        "(LD_LIBRARY_PATH) envornment variable.\n");
      return;
    }
  #endif /* XMLSEC_CRYPTO_DYNAMIC_LOADING */
  // init crypto
  if (xmlSecCryptoAppInit(NULL) < 0) {
    rb_raise(rb_eRuntimeError, "unable to initialize crypto engine");
    return;
  }
  // init xmlsec-crypto library
  if (xmlSecCryptoInit() < 0) {
    rb_raise(rb_eRuntimeError, "xmlsec-crypto initialization failed");
  }

  /* ruby classes & objects */
  Init_Nokogiri_ext();
}

