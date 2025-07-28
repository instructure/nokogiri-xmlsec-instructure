#ifndef NOKOGIRI_EXT_XMLSEC_XMLSECRB_H
#define NOKOGIRI_EXT_XMLSEC_XMLSECRB_H

#include "common.h"

#include <ruby.h>

#include <libxml/tree.h>
#include <libxml/xmlmemory.h>
#include <libxml/parser.h>
#include <libxml/xmlstring.h>

#include <libxslt/xslt.h>

#include <xmlsec/xmlsec.h>
#include <xmlsec/xmltree.h>
#include <xmlsec/xmldsig.h>
#include <xmlsec/xmlenc.h>
#include <xmlsec/templates.h>
#include <xmlsec/crypto.h>
#include <xmlsec/errors.h>

#include <nokogiri.h>
// Lifted from modern nokogiri.h
#ifndef Noko_Node_Get_Struct
  #define Noko_Node_Get_Struct(obj,type,sval) ((sval) = (type*)DATA_PTR(obj))
#endif

// TODO(awong): Support non-gcc and non-clang compilers.
#define EXTENSION_EXPORT __attribute__((visibility("default")))

VALUE sign(VALUE self, VALUE rb_opts);
VALUE verify_with(VALUE self, VALUE rb_opts);
VALUE encrypt_with_key(VALUE self, VALUE rb_rsa_key_name, VALUE rb_rsa_key,
                       VALUE rb_opts);
VALUE decrypt_with_key(VALUE self, VALUE rb_key_name, VALUE rb_key);
VALUE set_id_attribute(VALUE self, VALUE rb_attr_name);
VALUE get_id(VALUE self, VALUE rb_id);

void Init_Nokogiri_ext(void);

extern VALUE rb_cNokogiri_XML_Document;
extern VALUE rb_eSigningError;
extern VALUE rb_eVerificationError;
extern VALUE rb_eKeystoreError;
extern VALUE rb_eEncryptionError;
extern VALUE rb_eDecryptionError;

#endif // NOKOGIRI_EXT_XMLSEC_XMLSECRB_H
