//! Some constants for XHTML 1.1.  Just for consistencies sake really.
//!
//! This module is depended upon by Public.Syndication.ATOM if any XHTML elements are found.
//!

#if !constant(Public.Parser.XML2)
static void create(mixed ... args)
{
  throw(Error.Generic("This module depends on Public.Parser.XML2, please install it with monger.\nCheck http://module.gotpike.org/ for more information.\n\n"));
}
#else

import Public.Parser;

constant CONTENT_TYPE = "text/html";
constant XMLNS = "http://www.w3.org/1999/xhtml";
constant MAJOR = 1;
constant MINOR = 1;

#endif
