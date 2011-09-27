//! Some constants for XHTML 1.1.  Just for consistencies sake really.
//!
//! This module is depended upon by Public.Web.ATOM if any XHTML elements are found.
//!

#if !constant(Public.Parser.XML2)
throw(({ "This module depends on Public.Parser.XML2, please install it with monger.\nCheck http://module.gotpike.org/ for more information.\n\n", backtrace() }));
#else

import Public.Parser;

constant CONTENT_TYPE = "text/html";
constant XMLNS = "http://www.w3.org/1999/xhtml";
constant MAJOR = 1;
constant MINOR = 1;
constant TEST = #string "test.xml";

#endif
