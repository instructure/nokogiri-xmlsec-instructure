#ifndef NOKOGIRI_EXT_XMLSEC_COMMON_H
#define NOKOGIRI_EXT_XMLSEC_COMMON_H

#ifndef TRUE
#define TRUE 1
#endif
#ifndef FALSE
#define FALSE 0
#endif

typedef int BOOL;

#define Noko_Node_Get_Struct(obj,type,sval) ((sval) = (type*)DATA_PTR(obj))

#endif // NOKOGIRI_EXT_XMLSEC_COMMON_H
